extends Node

var active_button: BuildingButton = null

func _ready() -> void:
	add_to_group("tracker")


# only one active button at a time	
func button_activated(inc_active_button: BuildingButton) -> void:
	# check if active_button is already active	
	if _free_cursor(inc_active_button):
		return

	# for all non-active buttons with cursor, clear to prioritize active button		
	for button in get_tree().get_nodes_in_group("building_buttons"):
		if button != inc_active_button:
			_free_cursor(button)
			
	active_button = inc_active_button


## Given InputEvent unhandled by UI, check for active BuildingCursor
func _unhandled_input(event: InputEvent) -> void:
	if not active_button:
		return
	
	var cursor: Building = active_button.cursor_instance
	if event.is_action_pressed("cancel_building_button"):
		_free_cursor(active_button)
		active_button = null
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("engage_building_button"):
		if cursor and is_instance_valid(cursor):
			active_button._place_building()
			active_button.cursor_instance = null
			active_button = null
			
		get_viewport().set_input_as_handled()


func _free_cursor(target_button: BuildingButton) -> bool:
	var node_to_free: Building = ( 
		target_button.cursor_instance
	)

	# is_instance_valid prevents double free
	if node_to_free and is_instance_valid(node_to_free):
		print("freeing ", node_to_free, " from ", target_button)
		node_to_free.queue_free()
		target_button.cursor_instance = null
		return true
	
	return false
