class_name PositionLock
extends Camera2D


@export var player:CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var ppos:Vector2 = player.global_position
	
	global_position = ppos
