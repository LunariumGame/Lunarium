class_name HUD
extends CanvasLayer


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()


func _on_next_turn_pressed() -> void:
	game_manager.end_turn()
	
# note this will be updated to be replaced with specific Building GUI (building selector)
# for now, just randomly populates Iron Refinery
func _on_building_pressed() -> void:
