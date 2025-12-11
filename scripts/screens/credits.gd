extends CanvasLayer

# enum to store from where the credits were opened
enum Callers {START, DEFEAT, VICTORY}

var caller:int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("credits called")
	visible = true


func close():
	match caller:
		Callers.DEFEAT:
			get_tree().quit()
		Callers.VICTORY:
			Signals.credits_stopped_victory.emit()

	window_manager.pop()
	queue_free()
