## Not used in building_button, but keep for adjacency functionality for existing buildings
class_name BuildingCollider	
extends Area2D

var parent_building: Building

# create unique Shape2D for each building, set dimensions
func _ready() -> void:
	parent_building = get_parent()
	var collision_shape = $CollisionShape2D
	if collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()
		# extents expects half width and half height
		collision_shape.shape.extents = parent_building.get_frame_wh() / 2

# test: better functionality with building manager? see build_button
func is_overlapping() -> bool:
	return not get_overlapping_areas().is_empty()
