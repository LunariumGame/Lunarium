extends Sprite2D


func get_frame_wh() -> Vector2:
	return Vector2(
		texture.get_width() / hframes, texture.get_height() / vframes
	)
