extends CanvasLayer

@onready var movie := $CBoxContainer/VideoStreamPlayer
@onready var score := $IntroScore

func _ready():
	# wait some time for the opening screen to go away
	await get_tree().create_timer(2.0).timeout
	
	# play the movie & audio
	movie.play()
	score.play()


func _on_movie_end():
	# signal that movie has ended
	Signals.opening_movie_stopped.emit()
	score.stop()
	
	# play main game music
	var main_music := get_node("/root/World/Audio/Music")
	if main_music:
		main_music.on_finished()
	close()


func close():
	# signal that movie has ended
	Signals.opening_movie_stopped.emit()
	
	window_manager.pop()
	queue_free()


func _on_skip_press() -> void:
	close()
