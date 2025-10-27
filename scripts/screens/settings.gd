extends Control

func _ready():
	get_parent().visible = false

func _input(event):
	if event.is_action_pressed("settings"):
		get_tree().paused = !get_tree().paused
		get_parent().visible = get_tree().paused
		print(get_parent())
