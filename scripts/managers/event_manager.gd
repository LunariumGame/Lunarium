class_name EventManager
extends Node

func _ready() -> void:
	Signals.turn_started.connect(_roll_runtime_event)


func _roll_runtime_event() -> void:
	if game_manager.state == game_manager.GameState.WON || game_manager.state == game_manager.GameState.LOST:
		# Do nothing if game was just won or lost
		return
		
	var rand = randf()
	print("%d", rand)
	# 80% nothing happens, 5% 
	if rand < 0.9:
		print("No event triggered")
		return
	elif rand < 0.92:
		print("Parasite event triggered")
		pass
	elif rand < 0.94:
		print("Electromagnetic storm event triggered")
		pass
	elif rand < 0.96:
		print("Fog event triggered")
		pass
	elif rand < 0.98:
		print("Plague event triggered")
		pass
	else:
		print("Sunny day event triggered")
		pass
