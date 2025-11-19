# building that follows cursor, then gets placed in the world
class_name BuildingCursor
extends Sprite2D

var building_instance = null


# determine what building should be placed in the world
func initialize_building(building_type: GameData.BuildingType) -> void:
	match building_type:
		GameData.BuildingType.ECO_DOME:
			building_instance = preload("res://scripts/buildings/eco_dome.gd")
		GameData.BuildingType.IRON_REFINERY:
			building_instance = preload("res://scripts/buildings/iron_refinery.gd")
		GameData.BuildingType.MECH_QUARTER:
			building_instance = preload("res://scripts/buildings/mech_quarter.gd")
		GameData.BuildingType.POWER_PLANT:
			building_instance = preload("res://scripts/buildings/power_plant.gd")
		GameData.BuildingType.RESIDENCE_BUILDING:
			building_instance = preload("res://scripts/buildings/residential_building.gd")
		_:
			push_error("attempted to place unrecognized building in world")


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
	pass 
