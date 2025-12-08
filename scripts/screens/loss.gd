extends CanvasLayer

@onready var banner := $VBoxContainer/AnimatedSprite2D

func _ready():
	# Make banner invisible at first
	banner.modulate.a = 0.0
	
	# Start playing the idle animation
	banner.play("idle")
	
	# Fade in over 1 second
	var tween = create_tween()
	tween.tween_property(banner, "modulate:a", 1.0, 1.0)


func close():
	window_manager.pop()
	queue_free()
