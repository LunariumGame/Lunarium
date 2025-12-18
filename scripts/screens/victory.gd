extends CanvasLayer

@onready var banner := $Control/CBoxContainer/VBoxContainer/AnimatedSprite2D
@onready var victory_audio := $AudioStreamPlayer
@onready var main_music: AudioStreamPlayer = get_node("/root/World/Audio/Music")

func _ready():
	# Make banner invisible at first
	banner.modulate.a = 0.0
	
	# stop background music
	if main_music:
		main_music.stop()
	
	victory_audio.play()
	banner.play("default")
	
	# Fade in over 1 second
	var tween = create_tween()
	tween.tween_property(banner, "modulate:a", 1.0, 3.0)

func close():
	game_manager.endless_mode_triggered()
	window_manager.pop()
	queue_free()


func _on_continue_pressed() -> void:
	victory_audio.stop()
	main_music.play()
	close()


func _on_quit_game_pressed() -> void:
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	get_tree().quit()
