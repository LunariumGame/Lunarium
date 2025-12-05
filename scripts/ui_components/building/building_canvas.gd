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
			# if placed, free cursor
			if building_cursor.place_building():
				call_deferred("queue_free")
			# otherwise cursor flashes red
			else:
				building_cursor.notify_not_placeable()	
