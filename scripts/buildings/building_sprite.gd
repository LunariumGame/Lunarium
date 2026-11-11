extends Sprite2D


func get_frame_wh() -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(
		texture.get_width() / hframes, texture.get_height() / vframes
	)
