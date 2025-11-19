# simply follows cursor (sprite insertion is handled by build button class)
class_name BuildingCursor
extends Sprite2D


func _process(delta: float) -> void:
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
