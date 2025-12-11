extends CanvasLayer

# enum to store from where the opening movie was played
enum Callers {START, GALLERY}

@onready var movie := $Control/CBoxContainer/VideoStreamPlayer
@onready var score := $IntroScore
@onready var star_twinkle: AudioStreamPlayer = $StarTwinkle


var caller:int = -1

func _ready():
	# wait some time for the opening screen to go away
	# play audio
	score.play()
	await get_tree().create_timer(1.0).timeout
	
	# play the movie
	movie.play()
	# Star should twinkle 23.5 seconds into movie (perfect timing as of writing this)
	await get_tree().create_timer(23.5).timeout
	star_twinkle.play()


func _on_movie_end():
	close()


func close():
	score.stop()
	
	# signal that movie has ended
	# if opened in the intro
	if caller == Callers.START:
		Signals.opening_movie_stopped_from_intro.emit()
	#elif caller == Callers.GALLERY:
		
		
	window_manager.pop()
	# play main game music again
	var main_music := get_node("/root/World/Audio/Music")
	if main_music:
		main_music.on_finished()
	queue_free()


func _on_skip_press() -> void:
	close()
