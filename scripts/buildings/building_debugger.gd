extends Label

@export var target:Building

func _init() -> void:
	if not OS.is_debug_build():
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "is_powered=%s
power_draw=%s" % [target.is_powered, target.get_power_draw()]
