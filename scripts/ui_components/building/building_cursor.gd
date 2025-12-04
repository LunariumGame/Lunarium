# building that follows cursor, then gets placed in the world
class_name BuildingCursor
extends Sprite2D

@export var red_cursor_duration: float = 0.5
@export var tile_size := Vector2i(16, 16)

var width: int
var height: int

var building_scene: PackedScene = null

## modulate BuildingCursor to indicate it is not placeable
func notify_not_placeable() -> void:
	modulate = Color.CRIMSON
	await get_tree().create_timer(red_cursor_duration).timeout
	modulate = Color.WHITE
	modulate.a = 0.5


## add a Building node to the colony from a BuildingButton event.
## returns a bool as defined in BuildingManager.build()
func place_building() -> bool:
	var is_built := false
	
	var building_instance: Building = building_scene.instantiate()
	if (building_instance == null):
		print_debug("building was not initialized prior to instantiation")
		return is_built
		

	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	

	building_instance.global_position = global_position
	
	print("successfully added to colony: ", building_instance.name)
	
	# log building in build manager array (also returns building ID
	# also notifies if placement was a success
	is_built = build_man.build(
		building_instance.building_spec, _get_grid_coordinates(),
		width, height
	)
	
	# only add child if placement is successful
	if is_built:
		colony_buildings_node.add_child(building_instance)
		
	return is_built


## translate raw global_position to whole integer grid coordinates.
## raw global_position is top_left of texture
func _get_grid_coordinates() -> Vector2i:
	var grid_x := int(global_position.x - (width / 2))
	var grid_y := int(global_position.y - (height / 2))
	return Vector2i(grid_x, grid_y)


func _ready() -> void:
	width = texture.get_width() * scale.x
	height = texture.get_height() * scale.y
	# assign BuildingCursor transparency to 50%
	modulate.a = 0.5


func _physics_process(_delta: float) -> void:
	global_position = (
		get_global_mouse_position().snapped(tile_size)
	)
