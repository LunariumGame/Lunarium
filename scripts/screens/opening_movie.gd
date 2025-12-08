extends CanvasLayer

@onready var movie := $HBoxContainer/VideoStreamPlayer

func _ready():
	# wait some time for the opening screen to go away
	await get_tree().create_timer(2.0).timeout
	
	# play the movie
	movie.play()


func _on_movie_end():
	# signal that movie has ended
	Signals.opening_movie_stopped.emit()
	close()


func close():
	window_manager.pop()
	queue_free()
