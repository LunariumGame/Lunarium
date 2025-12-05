@tool
extends Sprite2D


@export
var variant:int = 0:
	set(v):
		variant = v
		region_rect.position.x = 128 * variant


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
