class_name WorldScene
extends Node

@onready var tech_upgrade:TechTreeNode = get_node("TechTreeNode")
@onready var building_finder: ShapeCast2D = $BuildingFinder


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_manager.set_ui_root($UI/PopupWindowHolder)
	Signals.settings_opened.connect(open_settings_window)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	# Test upgrade
	tech_upgrade.unlocked = true
	tech_upgrade.purchase()


func _on_end_turn_pressed() -> void:
	game_manager.end_turn()


# only if the input hasn't been handled
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if window_manager.has_windows():
			# note that this happens only when the close signal has not been handled
			# fallback close() call
			# all windows must provide close method
			window_manager.back().close()
		else:
			open_settings_window()


# TODO: Should this be in the world.gd script?
func open_settings_window():
	var settings_scene = preload("res://scenes/screens/settings.tscn").instantiate()
	window_manager.push(settings_scene)


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
