class_name GameManager
extends Node


enum GameState {
	IN_PROGRESS,
	WON,
	LOST,
}


const WIN_CONDITION_MIN_POPULATION:int = 100

const COLONIST_CONSUMPTION_PER_TURN:float = 1
const STARVING_COLONIST_DEATH_RATE_PER_TURN:float = 0.5

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
	
	_logic_food_consumption_and_starvation()
	
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
	

func _logic_food_consumption_and_starvation() -> void:
	# feed as many colonists as possible
	var food:float = resource_manager.get_resource(ResourceManager.ResourceType.FOOD)
	var population:int = roundi(resource_manager.get_resource(ResourceManager.ResourceType.POPULATION))
	var fed_colonists:int = mini(population, floori(food / COLONIST_CONSUMPTION_PER_TURN))
	
	# apply starvation
	var starving_colonists:int = population - fed_colonists
	var deaths:int = ceili(starving_colonists * STARVING_COLONIST_DEATH_RATE_PER_TURN)
	
	# apply calculated effects
	resource_manager.add_precalculated(ResourceManager.ResourceType.FOOD, -COLONIST_CONSUMPTION_PER_TURN * fed_colonists)
	if deaths > 0:
		resource_manager.add_precalculated(ResourceManager.ResourceType.POPULATION, -deaths)
