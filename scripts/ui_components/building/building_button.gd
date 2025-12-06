# On click of building button, populate BuildingCursor
class_name BuildingButton
extends Button

@export var tile_size := Vector2i(32, 32)

@export var building_cursor: PackedScene
var cursor_instance: Building
var cursor_sprite: AnimatedSprite2D
var cursor_area: Area2D

# current position of cursor in building manager coords
var ptr: Vector2i


func _ready() -> void:
	add_to_group("building_buttons")
	pressed.connect(_populate_cursor_on_click)
	

# populate with PackedScene building and follow cursor
func _populate_cursor_on_click() -> void:
	# if the BuildingCanvas already exists, return
	var existing_cursor: Building = get_node_or_null(^"BuildingCursor")
	if existing_cursor and is_instance_valid(existing_cursor):
		return
		
	# set as active building button
	get_tree().call_group("tracker", "button_activated", self)
	
	_instantiate_cursor()
	print("Adding ", cursor_instance," child with button: ", name)


# instanatiate building as a cursor with characteristics
func _instantiate_cursor() -> void:
	cursor_instance = building_cursor.instantiate()
	cursor_instance.set_cursor_mode(true)
	cursor_instance.name = "BuildingCursor"
	add_child(cursor_instance)
	
	cursor_sprite = cursor_instance.get_node("AnimatedSprite2D")
	cursor_sprite.modulate.a = 0.5
	cursor_sprite.play("off_u1")
	
	cursor_area = cursor_instance.get_node("Area2D")


# follow cursor
func _process(_delta: float) -> void:
	if cursor_instance != null and is_instance_valid(cursor_instance):
		cursor_instance.global_position = (
			get_global_mouse_position().snapped(tile_size)
		)

		ptr = cursor_instance.global_position.snapped(tile_size)
		# if it returns a valid building id, can't place here
		# if it doesn't exist yet, can place
		if build_man._buildings.get(ptr, 0):
			cursor_instance.modulate = Color.RED
		else:
			cursor_instance.modulate = Color.WHITE


## add a Building node to the colony from a BuildingButton event.
## log location in BuildingManager for other in-game uses.
func _place_building() -> void:
	
	if build_man._buildings.get(ptr, 0):
		return
	
	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	
	var frame_size: Vector2 = cursor_instance.get_frame_wh()
	var top_left_pos := (
		Vector2i(cursor_instance.global_position.x - (frame_size.x / 2),
				 cursor_instance.global_position.y - (frame_size.y / 2))
	)

	# log building in build manager array
	var building_id = build_man.build(
		cursor_instance.building_spec, top_left_pos,
		frame_size.x, frame_size.y
	)
	
	cursor_instance.reparent(colony_buildings_node, true)
	# I hate this, but necessary evil here
	cursor_instance.global_position = (
		get_viewport().get_canvas_transform().affine_inverse() 
		* 
		get_global_mouse_position().snapped(tile_size)
	)
	
	cursor_instance.set_cursor_mode(false)
	cursor_instance.name = (
		cursor_instance.get_script().get_global_name() + "-" + str(building_id)
	)
	cursor_sprite.play("idle_u1")
	cursor_sprite.modulate.a = 1.0
