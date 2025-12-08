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
@onready var upgrade: Button = $HUD/BotLeft/Box/VBox/InspectorPanel/SelectedBuildingInspector/VBox/MarginContainer2/UpgradeAndDestroy/Upgrade
@onready var destroy: Button = $HUD/BotLeft/Box/VBox/InspectorPanel/SelectedBuildingInspector/VBox/MarginContainer2/UpgradeAndDestroy/Destroy


static var same_building_in_a_row: int
var prev_building_id: int
var selected_building_id: int = -1

func _ready() -> void:
	layer = order_man.order.HUD
	
	var sel_bldg_panel := system_panels[system_panels.size() - 1]
	var upgrade_button := sel_bldg_panel.get_node("VBox/MarginContainer2/UpgradeAndDestroy/Upgrade")
	var destroy_button := sel_bldg_panel.get_node("VBox/MarginContainer2/UpgradeAndDestroy/Destroy")
	
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	destroy_button.pressed.connect(_on_destroy_pressed)
	
	Signals.building_selected.connect(_on_building_selected)


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()


func _on_next_turn_pressed() -> void:
	game_manager.end_turn()
	next_turn_button.start_cooldown()


#region System Buttons\
func toggle_panel(system: Systems) -> void:
	same_building_in_a_row = 0
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
	upgrade.visible = true
	destroy.visible = true
	# If headquarters, no upgrade/destroy buttons
	if building_id == -1:
		upgrade.visible = false
		destroy.visible = false
	
	# Hide all normal system panels + unpress buttons
	for i in Systems.values():
		if i < system_buttons.size():
			system_buttons[i].button_pressed = false
		system_panels[i].visible = false

	# Show the selected building inspector (which is the last panel)
	var selected_index := system_panels.size() - 1
	var panel := system_panels[selected_index]
	panel.visible = true

	# payload
	var payload_container := panel.get_node("VBox/MarginContainer/PayloadContainer")
	for child in payload_container.get_children():
		child.queue_free()
	for key in payload.keys():
		var value = payload[key]
		var info_label = Label.new()
		info_label.theme = load("res://resources/ui/oldsteam.tres")
		info_label.text = str(key) + ": " + str(value)
		if key == "\n": info_label.text = ""
		payload_container.add_child(info_label)

	# Currentlyinspecting label
	var building_type_index = build_man.get_building_type_from_id(building_id)
	var building_type_name: String = build_man.BuildingType.find_key(building_type_index)
	var pretty_name = building_type_name.replace("_", " ")
	currentlyInspectingLabel.text = str(pretty_name)
	
	# fetch live node
	var building_node: Building = utils.fetch_building(building_id)
	
	# Funny easter egg
	if building_id == prev_building_id:
		same_building_in_a_row += 1
	else:
		same_building_in_a_row = 0
	if same_building_in_a_row >= 15:
		currentlyInspectingLabel.text = "calm down lol"
	prev_building_id = building_id


func _on_tech_tree_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.TECH)


func _on_building_manager_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.BUILDING)


func _on_building_selected(building_id: int, payload: Dictionary) -> void:
	selected_building_id = building_id
	toggle_panel_selected_building(building_id, payload)


func _on_upgrade_pressed() -> void:
	if selected_building_id <= 0:
		return
	
	var building: Building = build_man.building_id_to_node[selected_building_id]
	building.upgrade_level()

	var payload := building._get_selection_payload()
	toggle_panel_selected_building(selected_building_id, payload)


func _on_destroy_pressed() -> void:
	if selected_building_id <= 0:
		return
	
	var building: Building = build_man.building_id_to_node[selected_building_id]
	await building.destroy()
	await get_tree().create_timer(0.1).timeout
	Signals.building_stats_changed.emit()
	selected_building_id = -1


func resetCurrInspLabel() -> void:
	currentlyInspectingLabel.text = ""


#endregion
