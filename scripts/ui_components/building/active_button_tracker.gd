extends Node


func _ready() -> void:
	add_to_group("tracker")


# only one active button at a time
func button_activated(active_button: BuildingButton) -> void:
	print("")
	for button in get_tree().get_nodes_in_group("building_buttons"):
		if button != active_button:
			print("")
			var node_to_free: BuildingCursor = ( 
				button.get_node_or_null("building_instance")
			)
			print("valid cursor instance: ", button)
			print("status of node to free: ", node_to_free)

			if node_to_free and is_instance_valid(node_to_free):
				print("freeing ", node_to_free, " from ", button)
				node_to_free.queue_free()
				button.building_instance = null
			else:
				push_warning(button, " did not have a node freed")
