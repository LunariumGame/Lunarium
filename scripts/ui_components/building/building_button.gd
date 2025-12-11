# On click of building button, populate BuildingCursor
class_name BuildingButton
extends ButtonWrapper

@export var tile_size := Vector2i(32, 32)
@export var building_cursor: PackedScene

var cursor_instance: Building
var cursor_sprite: Sprite2D
var cursor_area: Area2D
var cursor_anim_manager: AnimationManager
var create_audio: AudioStreamPlayer2D
var ptr: Vector2i # current position of cursor in building manager coords
var last_hovered_building: Building = null

const highlighted_building_color:Color = Color(1.188, 1.4, 0.561, 1.0)

@onready var cost_label: Label = $"../../../../Costs/BuildingCost"
@onready var hud: HUD = get_tree().get_root().get_node("World/UI/HUD")

func _ready() -> void:
	super()
	add_to_group("building_buttons")
	pressed.connect(_populate_cursor_on_click)


# populate with PackedScene building and follow cursor
func _populate_cursor_on_click() -> void:
	# if a building cursor already exists, return
	if cursor_instance != null and is_instance_valid(cursor_instance):
		return
		
	# set as active building button
	get_tree().call_group("tracker", "button_activated", self)
	
	_instantiate_cursor()
	print("Adding ", cursor_instance," child with button: ", name)

	# Update cost label
	populate_cost_label(cursor_instance.building_spec)

# instantiate building as a cursor with characteristics
func _instantiate_cursor() -> void:
	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	cursor_instance = building_cursor.instantiate()
	cursor_instance.set_cursor_mode(true)
	cursor_instance.name = "BuildingCursor"
	colony_buildings_node.add_child(cursor_instance)
	
	cursor_sprite = cursor_instance.get_node("Sprite2D")
	cursor_area = cursor_instance.get_node("Area2D")
	cursor_anim_manager = cursor_instance.get_node("AnimationTree")
	create_audio = cursor_instance.get_node("Audio/Create")
	cursor_anim_manager.update_animation(cursor_anim_manager.StateAction.OFF)


# follow cursor
func _process(_delta: float) -> void:
	if cursor_instance != null and is_instance_valid(cursor_instance):
		
		# cumbersome: translate BuildingCursor coords from canvas -> world on mouse pos
		var canvas_to_world_transform: Transform2D = get_viewport().get_canvas_transform().affine_inverse()
		var mouse_pos_world: Vector2 = canvas_to_world_transform * get_global_mouse_position()

		cursor_instance.global_position = mouse_pos_world.snapped(tile_size)
		
		# if collision/not enough resources, notify with red sprite
		if cursor_area.is_overlapping() || !build_man.can_purchase(cursor_instance.building_spec, 0):
			cursor_instance.modulate = Color.RED
		else:
			cursor_instance.modulate = Color.WHITE

	else: # Highlight buildings on hover / select (non-cursors)
		var canvas_to_world := get_viewport().get_canvas_transform().affine_inverse()
		var mouse_world: Vector2 = canvas_to_world * get_global_mouse_position()

		# Point collision query
		var space_state := get_world_2d().direct_space_state
		var params := PhysicsPointQueryParameters2D.new()
		params.position = mouse_world
		params.collide_with_areas = true
		params.collide_with_bodies = false

		var results = space_state.intersect_point(params)

		# Remove prev highlight
		if last_hovered_building != null and is_instance_valid(last_hovered_building):
			last_hovered_building.get_node("Sprite2D").modulate = Color.WHITE
			#last_hovered_building.get_node("Sprite2D").material.set("shader_parameter/enabled", false) # NOTE: this is for building pixel outline, sprites had too many artifacts at the time
			last_hovered_building = null

		# Check for building under cursor
		for hit in results:
			var area :Area2D = hit.collider
			var building := area.get_parent()

			if building is Building:
				if not building.is_cursor:
					building.get_node("Sprite2D").modulate = highlighted_building_color
					#building.get_node("Sprite2D").material.set("shader_parameter/enabled", true) # NOTE: this is for building pixel outline, sprites had too many artifacts at the time
				last_hovered_building = building
				break


## add a Building node to the colony from a BuildingButton event.
## log location in BuildingManager for other in-game uses.
func _place_building() -> bool:
	if cursor_area.is_overlapping():
		return false
	
	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	
	var frame_size: Vector2 = cursor_sprite.get_frame_wh()
	var top_left_pos := (
		Vector2i(cursor_instance.global_position.x - (frame_size.x / 2),
				 cursor_instance.global_position.y - (frame_size.y / 2))
	)

	# log building in build manager array
	var building_id = build_man.build(
		cursor_instance, top_left_pos,
		frame_size.x, frame_size.y
	)
	
	if building_id <= 0:
		return false
	
	cursor_instance.reparent(colony_buildings_node, true)
	cursor_instance.set_cursor_mode(false)
	cursor_instance.modulate = Color.WHITE
	cursor_instance.emit_built_signal()
	cursor_instance.name = (
		cursor_instance.get_script().get_global_name() + "-" + str(building_id)
	)
	cursor_instance.building_id = building_id
	# creation animation, then idling
	cursor_anim_manager.update_animation(cursor_anim_manager.StateAction.CREATE)
	# creation audio
	create_audio.play()
	
	return true


# Populate cost label with appropriate cost of building
func populate_cost_label(build_spec: BuildingSpec) -> void:
	var building_type_name = build_man.BuildingType.find_key(build_spec.type)
	var pretty_name = building_type_name.replace("_", " ")
	cost_label.text = str(pretty_name) + " COSTS\n\n"
	var cost_levels = build_spec.cost_levels
	var cost = cost_levels[cursor_instance.current_level - 1]
	cost_label.text += align_costs(cost.cost)


# For building cost label
func align_costs(costs: Dictionary) -> String:
	var rows: Array[String] = []
	var numbers: Array[String] = []

	# Convert all numbers to strings
	for type in costs.keys():
		numbers.append(str(int(costs[type])))

	# Find longest number string
	var max_len = 0
	for n in numbers:
		max_len = max(max_len, n.length())

	# Build aligned rows
	for type in costs.keys():
		if type == ResourceManager.ResourceType.POPULATION:
			continue
		var num_str = str(int(costs[type]))
		var padding = " ".repeat(max_len - num_str.length() + 2)  # +1 = space before label
		rows.append(num_str + padding + ResourceManager.ResourceType.keys()[type])
	
	return "\n".join(rows)
