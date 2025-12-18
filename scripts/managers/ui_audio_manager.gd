extends Node

# Use a dynamic path to fetch the node
@onready var button_click: AudioStreamPlayer = $ButtonClick 


func play_button_click():
		button_click.play()
