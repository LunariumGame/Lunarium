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
var _computed_electricity_capacity:float = 0

var state := GameState.IN_PROGRESS


func _ready() -> void:
	Signals.building_built.connect(recompute_electricity)
	Signals.building_stats_changed.connect(recompute_electricity)


func end_turn() -> void:
	if not GameState.IN_PROGRESS == state:
		return

	Signals.turn_ended.emit(turn)
	Signals.turn_ended_power_plant.emit(turn)
	Signals.turn_ended_eco_dome.emit(turn)
	Signals.turn_ended_refinery.emit(turn)
	Signals.turn_ended_residential.emit(turn)
	
	# Handle electricity calculations
	resource_manager.set_resource(ResourceManager.ResourceType.ELECTRICITY, 0)

	_logic_food_consumption_and_starvation()
	
	if _win_condition_satisfied():
		state = GameState.WON
		print_debug("Game win triggered")
		Signals.game_won.emit()
		return
	
	turn += 1
	Signals.turn_started.emit(turn)
	
	# electricity recomputation handles reactors
	recompute_electricity(null)
	
	Signals.turn_started_power_plant.emit(turn)
	Signals.turn_started_eco_dome.emit(turn)
	Signals.turn_started_refinery.emit(turn)
	Signals.turn_started_residential.emit(turn)


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


func get_electricity_usage() -> float:
	var total_usage := 0.0
	var placed_buildings := get_node("/root/World/PlacedBuildings").get_children()
	for building in placed_buildings:
		# Exclude power plants themselves
		if building is Building and not building is PowerPlant:
			total_usage += building.get_power_draw()
	return total_usage


func get_total_housing_capacity() -> int:
	var total_capacity := 0
	var placed_buildings := get_node("/root/World/PlacedBuildings").get_children()
	for building in placed_buildings:
		if building is Residential:
			total_capacity += building.get_housing_capacity()
	return total_capacity


func get_total_elec_capacity() -> int:
	var total_capacity := 0
	var placed_buildings := get_node("/root/World/PlacedBuildings").get_children()
	for building in placed_buildings:
		if building is PowerPlant:
			total_capacity += building._get_production_rate()
	return total_capacity


func get_resource_cap(resource:ResourceManager.ResourceType) -> float:
	match resource:
		ResourceManager.ResourceType.ELECTRICITY: return get_total_elec_capacity()
		ResourceManager.ResourceType.POPULATION: return get_total_housing_capacity()
		_: return NAN


func recompute_electricity(building: Building) -> void:
	resource_manager.set_resource(ResourceManager.ResourceType.ELECTRICITY, 0)
	Signals.recompute_power_plants.emit()
	_computed_electricity_capacity = resource_manager.get_resource(ResourceManager.ResourceType.ELECTRICITY)
	Signals.turn_process_power_draw.emit(turn)
	Signals.resource_value_changed.emit()
	Signals.electricity_recomputed.emit()
