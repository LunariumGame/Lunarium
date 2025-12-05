class_name BuildingAnimations
extends AnimatedSprite2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# default idle animation
	play("idle_u1")
