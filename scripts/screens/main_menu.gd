class_name MainMenuScene
extends CanvasLayer


func _ready() -> void:
	layer = layers.order.MAIN_MENU


func _on_start_game_pressed() -> void:
	close()


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func close():
	queue_free()
