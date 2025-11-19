# building that follows cursor, then gets placed in the world
class_name BuildingCursor
extends Sprite2D

var building_scene = null


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
		GameData.BuildingType.RESIDENCE_BUILDING:
			building_scene = preload("res://scenes/buildings/residential_building.tscn")
		_:
			push_error("attempted to place unrecognized building in world")
	print("building selected: ", building_scene.resource_path)


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("cancel_building_button"):
			get_viewport().set_input_as_handled()
			queue_free()
		elif event.is_action_pressed("engage_building_button"):
			get_viewport().set_input_as_handled()
			print("maybe place?")
			_place_building()
			call_deferred("queue_free")


func _place_building() -> void:
	var building_instance = building_scene.instantiate()
	
	if (building_instance == null):
		push_error("<building_cursor.gd, L45> building was not initialized prior to instantiation")
		
	
