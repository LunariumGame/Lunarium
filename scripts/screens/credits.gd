extends CanvasLayer


func _ready() -> void:
	print("credits called")
	visible = true


# called when "continue" button is clicked
func close():
	window_manager.pop()
	queue_free()
