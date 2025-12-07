class_name WorldScene
extends Node

@onready var building_finder: ShapeCast2D = $BuildingFinder


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# window_manager needs these
	window_manager.set_ui_root($UI/PopupWindowHolder)
	window_manager.set_main_menu_holder($UI/MainMenuHolder)
	
	window_manager.open_main_menu_screen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass


func _on_end_turn_pressed() -> void:
	game_manager.end_turn()


## Get the buildings in a given area. Affected by the area's mask.
static func get_buildings_in_area(area:Area2D) -> Array[Building]:
	return area.get_overlapping_bodies().filter(
		func (n) -> bool:
			return n is Building
	)


func get_buildings_within_rect(rect:Rect2) -> Array[Building]:
	var shape := RectangleShape2D.new()
	shape.size = rect.size

	building_finder.global_position = rect.position + rect.size / 2
	building_finder.shape = shape
	building_finder.force_shapecast_update()

	var results:Array[Building] = []
	for collision in building_finder.get_collision_count():
		var collider:Object = building_finder.get_collider(collision)
		if collider is Building:
			results.push_back(collider)
	
	return results
