class_name ButtonWrapper
extends Button


func _ready() -> void:
	self.pressed.connect(ui_audio_manager.play_button_click)
