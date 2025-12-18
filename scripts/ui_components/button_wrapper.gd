class_name ButtonWrapper
extends Button


func _ready() -> void:
	pressed.connect(_playback_sound)


func _playback_sound() -> void:
	ui_audio_manager.play_button_click()
