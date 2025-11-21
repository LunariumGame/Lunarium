class_name HUD
extends CanvasLayer

enum Systems {TECH, BUILDING, BOT}

@onready var next_turn_button:Button = %NextTurn
@onready var system_buttons: Array[Button] = [
	%SystemButtons/TechTree,
	%SystemButtons/BuildingManager,
	%SystemButtons/BotManager
]
@onready var system_panels: Array[PanelContainer] = [
	%InspectorPanel/TechInspector,
	%InspectorPanel/BuildingInspector,
	%InspectorPanel/BotInspector
]


func _ready() -> void:
	print("layers value: ", layers.order.HUD)
	layer = layers.order.HUD


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()


func _on_next_turn_pressed() -> void:
	game_manager.end_turn()
	next_turn_button.start_cooldown()


#region System Buttons\
func toggle_panel(system: Systems) -> void:
	# Toggle off if already toggled
	if system_panels[system].visible == true:
		system_panels[system].visible = false;
		system_buttons[system].button_pressed = false;
		return
	
	# Toggle the rest off and enable selected
	for i in Systems.values():  # Loop over TECH, BUILDING, BOT
		var is_selected:bool = (i == system)
		system_buttons[i].button_pressed = is_selected
		system_panels[i].visible = is_selected


func _on_tech_tree_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.TECH)


func _on_building_manager_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.BUILDING)


func _on_bot_manager_pressed() -> void:
	# Untoggle other buttons
	toggle_panel(Systems.BOT)


#endregion
