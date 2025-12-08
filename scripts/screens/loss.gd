extends CanvasLayer

@onready var sprite := $AnimatedSprite2D

func _ready():
	# Make sprite invisible at first
	sprite.modulate.a = 0.0
	
	# Start playing the idle animation
	sprite.play("idle")
	
	# Fade in over 1 second
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 1.0)


func close():
	window_manager.pop()
	queue_free()
