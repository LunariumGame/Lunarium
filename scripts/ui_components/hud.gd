class_name HUD
extends CanvasLayer

@onready var next_turn_button:Button = %NextTurn


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()


func _on_next_turn_pressed() -> void:
	game_manager.end_turn()
	next_turn_button.start_cooldown()


func _on_tech_tree_pressed() -> void:
	pass # Replace with function body.


func _on_building_manager_pressed() -> void:
	pass # Replace with function body.


func _on_bot_manager_pressed() -> void:
	pass # Replace with function body.
