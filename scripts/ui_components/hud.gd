class_name HUD
extends CanvasLayer

enum Systems {TECH, BUILDING, BOT}

@onready var next_turn_button:Button = %NextTurn
@onready var system_buttons: Array[Button] = [
	%TabButtons/TechTree,
	%TabButtons/BuildingManager,
	%TabButtons/BotManager
]
@onready var system_panels: Array[PanelContainer] = [
	%InspectorPanel/TechInspector,
	%InspectorPanel/BuildingInspector,
	%InspectorPanel/BotInspector,
	%InspectorPanel/SelectedBuildingInspector
]

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
		return
	
	# Toggle the rest off and enable selected
	for i in Systems.values():
		var is_selected: bool = (i == system)
		if i < system_buttons.size():
			system_buttons[i].button_pressed = is_selected
		system_panels[i].visible = is_selected


func toggle_panel_selected_building() -> void:
	# Hide all normal system panels + unpress buttons
	for i in Systems.values():
		if i < system_buttons.size():
			system_buttons[i].button_pressed = false
		system_panels[i].visible = false

	# Show the selected building inspector (which is the last panel)
	var selected_index := system_panels.size() - 1
	system_panels[selected_index].visible = true



func _on_tech_tree_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.TECH)


func _on_building_manager_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.BUILDING)


func _on_bot_manager_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.BOT)


func _on_building_selected(building_id: int) -> void:
	print("Toggled: ", building_id)
	toggle_panel_selected_building()


#endregion
