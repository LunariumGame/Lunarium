class_name GameManager
extends Node

var turn:int = 1


func _ready() -> void:
	pass
	

func end_turn() -> void:
	print("Ending turn ", turn)
	Signals.turn_ended.emit(turn)
	
	# Handle electricity calculations
	resource_manager.set_resource(ResourceManager.ResourceType.ELECTRICITY, 0)
	Signals.turn_electricity_generation.emit(turn)
	
	turn += 1
	print("Starting turn ", turn)
	Signals.turn_started.emit(turn)
