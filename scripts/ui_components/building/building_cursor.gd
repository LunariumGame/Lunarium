# building that follows cursor, then gets placed in the world
class_name BuildingCursor
extends Sprite2D

var width: float
var height: float

var tile_size: Vector2

var building_scene: PackedScene = null

var type_to_place: build_man.BuildingType = build_man.BuildingType.EMPTY


func not_placeable() -> bool:
	return build_man.placed_buildings.has(_get_grid_coordinates())


func place_building() -> void:
	var building_instance: Building = building_scene.instantiate()
	if (building_instance == null):
		push_error("building was not initialized prior to instantiation")

	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	colony_buildings_node.add_child(building_instance)
	

	building_instance.global_position = global_position
	
	print("successfully added to colony: ", building_instance.name)
	
	print("buildings world array prior to update: ", build_man.placed_buildings)
	# log building in build manager array (also returns building ID
	build_man.register_building(
		type_to_place, _get_grid_coordinates() 
	)
	print("buildings world array after update: ", build_man.placed_buildings)


func _get_grid_coordinates() -> Vector2i:
	var grid_x: int = int(global_position.x / tile_size.x)
	var grid_y: int = int(global_position.y / tile_size.y)
	return Vector2i(grid_x, grid_y)


func _ready() -> void:
	width = texture.get_width() * scale.x
	height = texture.get_height() * scale.y
	tile_size = Vector2(width, height)


func _physics_process(_delta: float) -> void:
	global_position = (
		get_global_mouse_position().snapped(tile_size)
	)
