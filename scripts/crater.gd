@tool
extends Sprite2D


@export
var variant:int = 0:
	set(v):
		variant = v
		region_rect = Rect2(
			Vector2(128 * variant, 256),
			Vector2(128, 128),
		)
