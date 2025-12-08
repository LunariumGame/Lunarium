extends CanvasLayer

@onready var banner := $VBoxContainer/AnimatedSprite2D
@onready var audio := $AudioStreamPlayer

func _ready():
	# Make banner invisible at first
	banner.modulate.a = 0.0
	
	# stop background music
	var main_music = get_node("/root/World/Audio/Music")
	if main_music:
		main_music.stop()
	# start victory music
	audio.play()
	
	
	
	# Start playing the idle animation
	banner.play("idle")
	
	# Fade in over 1 second
	var tween = create_tween()
	tween.tween_property(banner, "modulate:a", 1.0, 1.0)

func close():
	window_manager.pop()
	queue_free()
