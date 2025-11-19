extends Node


func _ready() -> void:
	add_to_group("tracker")


# only one active button at a time	
func button_activated(active_button: BuildingButton) -> void:
	# check if active_button is already active
	var existing_cursor: BuildingCursor = ( 
		active_button.get_node_or_null(^"BuildingCursor")
	)
	if existing_cursor and is_instance_valid(existing_cursor):
		existing_cursor.queue_free()
		active_button.building_instance = null
		return

	# for all non-active buttons with cursor, clear to prioritize active button		
	for button in get_tree().get_nodes_in_group("building_buttons"):
		if button != active_button:
			var node_to_free: BuildingCursor = ( 
				button.get_node_or_null(^"BuildingCursor")
			)

			# is_instance_valid prevents double free
			if node_to_free and is_instance_valid(node_to_free):
				print("freeing ", node_to_free, " from ", button)
				node_to_free.queue_free()
				button.building_instance = null
