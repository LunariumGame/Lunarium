extends AudioStreamPlayer

@export var TRACK_SPACING: float = 30


func on_finished() -> void:
	_play_next_track()
	

func _play_next_track() -> void:
	play()
	
	# wait to finish, wait x seconds
	await finished
	await get_tree().create_timer(TRACK_SPACING).timeout
	
	_play_next_track()
