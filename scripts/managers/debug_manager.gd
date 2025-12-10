extends Node

signal debug_overlays_enabled_changed(value:bool)

var debug_overlays_enabled:bool = false:
	set(v):
		debug_overlays_enabled = v
		debug_overlays_enabled_changed.emit(v)
	get:
		return debug_overlays_enabled


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug_overlays"):
		debug_overlays_enabled = not debug_overlays_enabled
