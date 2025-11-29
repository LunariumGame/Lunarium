@tool
class_name ScaleAwareTheme
extends Theme

@export var base_font_size:int = 18:
	set(v):
		base_font_size = v
		_update_scale(UiScaleManager.scale)

func _init() -> void:
	UiScaleManager.scale_changed.connect(_update_scale)
	_update_scale(UiScaleManager.scale)


func _update_scale(new_scale:float) -> void:
	default_font_size = base_font_size * new_scale
