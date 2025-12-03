class_name GameManager
extends Node


enum GameState {
	IN_PROGRESS,
	WON,
	LOST,
}


const WIN_CONDITION_MIN_POPULATION:int = 500

var turn:int = 1

var state := GameState.IN_PROGRESS

func _ready() -> void:
	pass
	

func end_turn() -> void:
	if not GameState.IN_PROGRESS == state:
		return
	
	print("Ending turn ", turn)
	Signals.turn_ended.emit(turn)
	
	# Handle electricity calculations
	resource_manager.set_resource(ResourceManager.ResourceType.ELECTRICITY, 0)
	Signals.turn_electricity_generation.emit(turn)
	
	if _win_condition_satisfied():
		state = GameState.WON
		print_debug("Game win triggered")
		Signals.game_won.emit()
		return
	
	turn += 1
	print("Starting turn ", turn)
	Signals.turn_started.emit(turn)


func _win_condition_satisfied() -> bool:
	var population:int = roundi(resource_manager.get_resource(ResourceManager.ResourceType.POPULATION))
	
	return population > WIN_CONDITION_MIN_POPULATION;
	
