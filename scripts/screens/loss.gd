extends CanvasLayer

@onready var banner := $Control/CBoxContainer/VBoxContainer/AnimatedSprite2D
@onready var audio := $AudioStreamPlayer

func _ready():
	# Make banner invisible at first
	banner.modulate.a = 0.0
	
	# Start playing the idle animation
	banner.play("idle")
	
	# Fade in over 1 second
	var tween = create_tween()
	tween.tween_property(banner, "modulate:a", 1.0, 3.0)
	
	# stop main music
	var main_music = get_node("/root/World/Audio/Music")
	if main_music:
		main_music.stop()
	# start victory music
	audio.play()


func close():
	window_manager.pop()
	queue_free()


func _on_quit_game_pressed() -> void:
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	get_tree().quit()
