class_name MainMenuScene
extends CanvasLayer


func _ready() -> void:
	layer = layers.order.MAIN_MENU
	Signals.settings_closed.connect(_on_settings_closed)


func _on_start_game_pressed() -> void:
	close()


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()
	get_node("UIElements").visible = false


func _on_settings_closed() -> void:
	get_node("UIElements").visible = true


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func close():
	queue_free()
