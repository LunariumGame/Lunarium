@tool
class_name ScaleAwareLabelSettings
extends LabelSettings


@export var base_font_size:int = 8:
	set(v):
		font_size = v
		base_font_size = v

func _init() -> void:
	call_deferred("_setup")


func _setup() -> void:
	if UiScaleManager:
		UiScaleManager.scale_changed.connect(_on_ui_scale_manager_scale_changed)
		_set_scale(UiScaleManager.scale)


func _on_ui_scale_manager_scale_changed(new_scale:float) -> void:
	_set_scale(new_scale)


func _set_scale(scale:float) -> void:
	font_size = base_font_size * scale
