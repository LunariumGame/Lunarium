extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(on_finished)


func on_finished() -> void:
	play()
