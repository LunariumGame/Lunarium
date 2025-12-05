@tool
extends Node2D

const CRATER = preload("uid://d23uxg6wsi6f3")

@export_tool_button("Regenerate", "Callable") var regenerate = _regenerate_craters

@export var crater_count:int = 500
@export var spread:int = 10000

func _regenerate_craters():
	var rng := RandomNumberGenerator.new()
	print_debug("Hi")
	for child in get_children():
		child.queue_free()
	
	for i in crater_count:
		var crater:Sprite2D = CRATER.instantiate()
		crater.variant = rng.rand_weighted([.4, .4, .2])
		self.add_child(crater, true)
		crater.owner = self
		crater.position = Vector2(
			rng.randi_range(-spread, spread),
			rng.randi_range(-spread, spread),
		)
