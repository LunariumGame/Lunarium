class_name HUD
extends CanvasLayer


func _on_settings_pressed() -> void:
	var World:WorldScene = get_tree().root.get_node("World")
	World.open_settings_window()
