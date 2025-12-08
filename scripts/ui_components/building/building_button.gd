# On click of building button, populate BuildingCursor
class_name BuildingButton
extends Button

@export var tile_size := Vector2i(32, 32)

@export var building_cursor: PackedScene
var cursor_instance: Building
var cursor_sprite: Sprite2D
var cursor_area: Area2D
var cursor_anim_manager: AnimationManager

# current position of cursor in building manager coords
var ptr: Vector2i


func _ready() -> void:
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
	cursor_sprite.modulate.a = 0.5
	cursor_area = cursor_instance.get_node("Area2D")
	cursor_anim_manager = cursor_instance.get_node("AnimationTree")
	cursor_anim_manager.update_animation(cursor_anim_manager.StateAction.OFF)


# follow cursor
func _process(_delta: float) -> void:
	if cursor_instance != null and is_instance_valid(cursor_instance):
		
		# cumbersome: translate BuildingCursor coords from canvas -> world on mouse pos
		var canvas_to_world_transform: Transform2D = get_viewport().get_canvas_transform().affine_inverse()
		var mouse_pos_world: Vector2 = canvas_to_world_transform * get_global_mouse_position()

		cursor_instance.global_position = mouse_pos_world.snapped(tile_size)
		# if collision, notify 
		if cursor_area.is_overlapping():
			cursor_instance.modulate = Color.RED
		else:
			cursor_instance.modulate = Color.WHITE


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
	cursor_instance.emit_built_signal()
	cursor_instance.name = (
		cursor_instance.get_script().get_global_name() + "-" + str(building_id)
	)
	cursor_instance.building_id = building_id
	cursor_sprite.modulate.a = 1.0
	# creation animation, then idling
	cursor_anim_manager.update_animation(cursor_anim_manager.StateAction.CREATE)
	return true
