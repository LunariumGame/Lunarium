# building that follows cursor, then gets placed in the world
class_name BuildingCursor
extends Sprite2D

var width: float
var height: float

var tile_size: Vector2

var building_scene: PackedScene = null


func place_building() -> void:
	var building_instance: Building = building_scene.instantiate()

	if (building_instance == null):
		push_error("building was not initialized prior to instantiation")

	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	colony_buildings_node.add_child(building_instance)

	building_instance.global_position = _placement_target_world_pos()

	print("successfully added to colony: ", building_instance.name)
	

func _ready() -> void:
	width = texture.get_width() * scale.x
	height = texture.get_height() * scale.y
	tile_size = Vector2(width, height)


func _physics_process(_delta: float) -> void:
	global_position = get_tree().root.get_canvas_transform() * _placement_target_world_pos()


func _world_target_pos() -> Vector2:
	return get_tree().root.get_canvas_transform().inverse() * get_viewport().get_mouse_position()


func _placement_target_world_pos() -> Vector2:
	return _world_target_pos().snapped(tile_size)
