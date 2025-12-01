class_name BuildingCanvas
extends CanvasLayer

var building_cursor: BuildingCursor


func _ready() -> void:
	layer = layers.order.CURSOR
	building_cursor = $BuildingCursor


func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("cancel_building_button"):
			get_viewport().set_input_as_handled()
			queue_free()
		elif event.is_action_pressed("engage_building_button"):
			get_viewport().set_input_as_handled()
			if building_cursor.is_placeable():
				building_cursor.place_building()
				call_deferred("queue_free")
			else:
				building_cursor.notify_not_placeable()
