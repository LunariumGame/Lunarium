@tool
extends Button

@export var ui_scale_setting:float = 1:
	set(v):
		ui_scale_setting = v
		if round(v) == v:
			self.text = "%d" % v
		else:
			self.text = "%s" % v

func _on_pressed() -> void:
	UiScaleManager.scale = self.ui_scale_setting
