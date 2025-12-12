class_name HUD
extends CanvasLayer

enum Systems {TECH, BUILDING}
const HEADQUARTERS: int = -1

static var same_building_in_a_row: int

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
@onready var building_cost: Label = $HUD/BotLeft/Box/VBox/InspectorPanel/BuildingInspector/HBoxContainer/Costs/BuildingCost
@onready var tutorial: Control = $Tutorial

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
	Signals.toggle_tutorial.connect(toggle_tutorial)


func flash_inspector_panel() -> void:
	var panel := %InspectorPanel
	panel.modulate = Color.WHITE

	# Kill any previous flash tween
	if panel.has_meta("flash_tween"):
		var old: Object = panel.get_meta("flash_tween")
		if is_instance_valid(old):
			old.kill()

	# Set dark green flash
	panel.modulate = Color("#4c5844")

	var tween := create_tween()
	tween.tween_property(panel, "modulate", Color.WHITE, 0.15)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	# cleanup meta when finished
	await tween.finished


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()


func _on_next_turn_pressed() -> void:
	if next_turn_button.disabled:
		return

	game_manager.end_turn()
	next_turn_button.start_cooldown()


#region System Buttons
func toggle_panel(system: Systems) -> void:
	%InspectorPanel.visible = true
	flash_inspector_panel()
	same_building_in_a_row = 0
	# Always hide the selected building panel whenever a system button is clicked
	var selected_index := system_panels.size() - 1
	system_panels[selected_index].visible = false

	# Toggle off if already toggled
	if system_panels[system].visible:
		if system < system_buttons.size():
			system_buttons[system].button_pressed = false
		system_panels[system].visible = false
		close_inspector()
		return
	
	# Toggle the rest off and enable selected
	for i in Systems.values():
		var is_selected: bool = (i == system)
		if i < system_buttons.size():
			system_buttons[i].button_pressed = is_selected
		system_panels[i].visible = is_selected

	# Set currentinyInspecting label to the panel type
	if system == Systems.BUILDING:
		currentlyInspectingLabel.text = "NEW BUILDING"
	else:
		resetCurrInspLabel()


func toggle_panel_selected_building(building_id: int, payload: Dictionary) -> void:
	%InspectorPanel.visible = true
	
	# Disable upgrade button if building is max level
	var building: Building = utils.fetch_building(building_id)
	if building.current_level == building.max_level || build_man.allowed_to_upgrade(building) == false:
		upgrade.disabled = true
	else:
		upgrade.disabled = false
		
	flash_inspector_panel()
	upgrade.visible = true
	#destroy.visible = true #NOTE: Disabled for now until destroy has features
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
		info_label.add_theme_font_size_override("font_size", 16)
		info_label.text = str(key) + ": " + str(value)
		if key == "\n" || key == "\n " || key == "\n  ": info_label.text = ""
		payload_container.add_child(info_label)

	# Currentlyinspecting label
	var building_type_index = build_man.get_building_type_from_id(building_id)
	var building_type_name: String = build_man.BuildingType.find_key(building_type_index)
	var pretty_name = building_type_name.replace("_", " ")
	currentlyInspectingLabel.text = "LVL " + str(building.current_level) + " " + str(pretty_name)	
	if pretty_name == "HEADQUARTERS":
		currentlyInspectingLabel.text = str(pretty_name)

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
	building_cost.text = "BUILDING COSTS"
	toggle_panel(Systems.BUILDING)


func _on_building_selected(building_id: int, payload: Dictionary) -> void:
	selected_building_id = building_id
	toggle_panel_selected_building(building_id, payload)


func _on_upgrade_pressed() -> void:
	if selected_building_id <= 0:
		return
	
	var building: Building = build_man.building_id_to_node[selected_building_id]
	if building.is_destroyed:
		return
	building.upgrade_level()
	
	if building.current_level == building.max_level:
		upgrade.disabled = true

	var payload := building._get_selection_payload()
	toggle_panel_selected_building(selected_building_id, payload)


func _on_destroy_pressed() -> void:
	if selected_building_id <= 0:
		return
	
	var building: Building = build_man.building_id_to_node[selected_building_id]
	
	await building.destroy()
	Signals.building_stats_changed.emit()
	Signals.recompute_power_plants.emit()

	selected_building_id = -1
	close_inspector()


func resetCurrInspLabel() -> void:
	currentlyInspectingLabel.text = ""
#endregion


## Given InputEvent unhandled by UI, close inspector
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("close_inspector"):
		close_inspector()
	if event.is_action_pressed("open_building_panel"):
		ui_audio_manager.button_click.play()
		toggle_panel(Systems.BUILDING)
	if event.is_action_pressed("next_turn"):
		_on_next_turn_pressed()


func close_inspector() -> void:
	for i in Systems.values():
		if i < system_buttons.size():
			system_buttons[i].button_pressed = false
			system_panels[i].visible = false
	resetCurrInspLabel()
	%InspectorPanel.visible = false


func toggle_tutorial() -> void:
	tutorial.visible = !tutorial.visible


func _on_toggle_tutorial_pressed() -> void:
	toggle_tutorial()
