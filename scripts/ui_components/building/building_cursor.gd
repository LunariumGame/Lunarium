# building that follows cursor, then gets placed in the world
class_name BuildingCursor
extends Sprite2D

var width: float
var height: float

var tile_size: Vector2

var building_scene: PackedScene = null


# determine what building should be placed in the world
func initialize_building(building_type: GameData.BuildingType) -> void:
	match building_type:
		GameData.BuildingType.ECO_DOME:
			building_scene = preload("res://scenes/buildings/eco_dome.tscn")
		GameData.BuildingType.IRON_REFINERY:
			building_scene = preload("res://scenes/buildings/iron_refinery.tscn")
		GameData.BuildingType.MECH_QUARTER:
			building_scene = preload("res://scenes/buildings/mech_quarter.tscn")
		GameData.BuildingType.POWER_PLANT:
			building_scene = preload("res://scenes/buildings/power_plant.tscn")
		GameData.BuildingType.RESIDENCE:
			building_scene = preload("res://scenes/buildings/residential.tscn")
		_:
			push_error("attempted to place unrecognized building in world")
	print("building selected: ", building_scene.resource_path)


func _ready() -> void:
	width = texture.get_width() * scale.x
	height = texture.get_height() * scale.y
	tile_size = Vector2(width, height)


func _physics_process(_delta: float) -> void:
	global_position = get_tree().root.get_canvas_transform() * _placement_target_world_pos()


func _place_building() -> void:
	var building_instance: Building = building_scene.instantiate()

	if (building_instance == null):
		push_error("building was not initialized prior to instantiation")

	var colony_buildings_node: Node = (
		get_tree().get_root().get_node("World/PlacedBuildings")
	)
	colony_buildings_node.add_child(building_instance)

	building_instance.global_position = _placement_target_world_pos()

	print("successfully added to colony: ", building_instance.name)


func _world_target_pos() -> Vector2:
	return get_tree().root.get_canvas_transform().inverse() * get_viewport().get_mouse_position()


func _placement_target_world_pos() -> Vector2:
	return _world_target_pos().snapped(tile_size)
