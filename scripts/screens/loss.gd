extends CanvasLayer

func close():
	window_manager.pop()
	queue_free()
