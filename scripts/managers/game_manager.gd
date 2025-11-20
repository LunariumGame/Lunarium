class_name GameManager
extends Node

var turn:int = 1


func _ready() -> void:
	pass
	

func end_turn() -> void:
	print("Ending turn ", turn)
	Signals.turn_ended.emit(turn)
	turn += 1
	print("Starting turn ", turn)
	Signals.turn_started.emit(turn)
