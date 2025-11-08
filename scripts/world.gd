class_name WorldScene
extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_manager.set_ui_root($UI/PopupWindowHolder)
	Signals.settings_opened.connect(open_settings_window)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_turn_pressed() -> void:
	game_manager.end_turn()


# only if the input hasn't been handled
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if window_manager.has_windows():
			# note that this happens only when the close signal has not been handled
			# fallback close() call
			# all windows must provide close method
			window_manager.back().close()
		else:
			open_settings_window()


func open_settings_window():
	var settings_scene = preload("res://scenes/screens/settings.tscn").instantiate()
	window_manager.push(settings_scene)
