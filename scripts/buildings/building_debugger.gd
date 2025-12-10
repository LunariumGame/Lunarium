extends Label

@export var target:Building


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	
	DebugManager.debug_overlays_enabled_changed.connect(_set_visibility)
	_set_visibility(DebugManager.debug_overlays_enabled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target == null:
		return
	
	text = "is_powered=%s\npower_draw=%s" % [target.is_powered, target.get_power_draw()]


func _set_visibility(v:bool) -> void:
	visible = v
