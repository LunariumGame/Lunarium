# simply follows cursor (sprite insertion is handled by build button class)
class_name BuildingCursor
extends Sprite2D


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

	
