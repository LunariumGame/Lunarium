# building that follows cursor, then gets placed in the world
class_name BuildingCursor
extends Sprite2D

var width: float
var height: float

var tile_size: Vector2

var building_scene: PackedScene = null


func is_placeable() -> bool:
	return true	

func place_building() -> void:
	var building_instance: Building = building_scene.instantiate()

	if (building_instance == null):
		push_error("building was not initialized prior to instantiation")

	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	colony_buildings_node.add_child(building_instance)
	
	#print("buildings world array prior to update: ", building_manager.buildings)

	building_instance.global_position = global_position
	
	#print("buildings world array after update: ", building_manager.buildings)
	
	print("successfully added to colony: ", building_instance.name)


func _ready() -> void:
	width = texture.get_width() * scale.x
	height = texture.get_height() * scale.y
	tile_size = Vector2(width, height)


func _physics_process(_delta: float) -> void:
	global_position = (
		get_global_mouse_position().snapped(tile_size)
	)
