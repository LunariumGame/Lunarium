class_name HUD
extends CanvasLayer

enum Systems {TECH, BUILDING}

@onready var next_turn_button:Button = %NextTurn
@onready var system_buttons: Array[Button] = [
	%TabButtons/TechTree,
	%TabButtons/BuildingManager
]
@onready var system_panels: Array[PanelContainer] = [
	%InspectorPanel/TechInspector,
	%InspectorPanel/BuildingInspector,
	%InspectorPanel/SelectedBuildingInspector
]
@onready var currentlyInspectingLabel:Label = %TabButtons/CurrentInspect

func _ready() -> void:
	layer = order_man.order.HUD
	Signals.building_selected.connect(_on_building_selected)


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()


func _on_next_turn_pressed() -> void:
	game_manager.end_turn()
	next_turn_button.start_cooldown()


#region System Buttons\
func toggle_panel(system: Systems) -> void:
	# Always hide the selected building panel whenever a system button is clicked
	var selected_index := system_panels.size() - 1
	system_panels[selected_index].visible = false

	# Toggle off if already toggled
	if system_panels[system].visible:
		if system < system_buttons.size():
			system_buttons[system].button_pressed = false
		system_panels[system].visible = false
		resetCurrInspLabel()
		return
	
	# Toggle the rest off and enable selected
	for i in Systems.values():
		var is_selected: bool = (i == system)
		if i < system_buttons.size():
			system_buttons[i].button_pressed = is_selected
		system_panels[i].visible = is_selected

	# Set currentinyInspecting label to the panel type
	if system == Systems.BUILDING:
		currentlyInspectingLabel.text = "BUILDINGS"
	else:
		resetCurrInspLabel()


func toggle_panel_selected_building(building_id: int, payload: Dictionary) -> void:
	# Hide all normal system panels + unpress buttons
	for i in Systems.values():
		if i < system_buttons.size():
			system_buttons[i].button_pressed = false
		system_panels[i].visible = false

	# Show the selected building inspector (which is the last panel)
	var selected_index := system_panels.size() - 1
	var panel := system_panels[selected_index]
	panel.visible = true

	# ID
	var label := panel.get_node("VBox/Label")
	label.text = "Selected Building ID: " + str(building_id)

	# payload
	var payload_container := panel.get_node("VBox/PayloadContainer")
	for child in payload_container.get_children():
		child.queue_free()
	for key in payload.keys():
		var value = payload[key]
		var info_label = Label.new()
		info_label.text = str(key) + ": " + str(value)
		payload_container.add_child(info_label)

	# Currentlyinspecting label
	var building_type_index = build_man.get_building_type_from_id(building_id)
	var building_type_name = build_man.BuildingType.find_key(building_type_index)
	var pretty_name = building_type_name.replace("_", " ")
	currentlyInspectingLabel.text = str(pretty_name)


func _on_tech_tree_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.TECH)


func _on_building_manager_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.BUILDING)


func _on_building_selected(building_id: int, payload: Dictionary) -> void:
	toggle_panel_selected_building(building_id, payload)


func resetCurrInspLabel() -> void:
	currentlyInspectingLabel.text = ""


#endregion
