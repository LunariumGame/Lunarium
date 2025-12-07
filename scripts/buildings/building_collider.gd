## Not used in building_button, but keep for adjacency functionality for existing buildings
class_name BuildingCollider	
extends Area2D

# change area size to n% to allow for adjacent tiled buildings
@export var tune_extents: float = 0.98
@onready var building_sprite = $"../Sprite2D"


# create unique Shape2D for each building, set dimensions
func _ready() -> void:
	var collision_shape = $CollisionShape2D
	if collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()
		# extents expects half width and half height
		collision_shape.shape.extents = building_sprite.get_frame_wh() / 2
		collision_shape.shape.extents *= tune_extents


## Returns true if self Building is overlapping with one or more other Buildings
func is_overlapping() -> bool:
	return not get_overlapping_areas().is_empty()
