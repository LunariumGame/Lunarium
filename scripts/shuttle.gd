extends Node

const BASE_TURNS_BETWEEN_SHUTTLES:int = 2

@export var max_colonists_per_shuttle:int = 5

var turns_to_shuttle:int = BASE_TURNS_BETWEEN_SHUTTLES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.turn_started.connect(_on_turn_started)


func _on_turn_started(_turn_number:int) -> void:
	turns_to_shuttle -= 1
	if turns_to_shuttle <= 0:
		turns_to_shuttle = get_turns_between_shuttles()
		_process_shuttle_arrival()
		


func get_turns_between_shuttles() -> int:
	return BASE_TURNS_BETWEEN_SHUTTLES


func get_shuttle_colonists() -> int:
	return randi_range(1, max_colonists_per_shuttle)


func _process_shuttle_arrival() -> void:
	var current_population := roundi(resource_manager.get_resource(ResourceManager.ResourceType.POPULATION))
	var max_allowed: int = game_manager.get_total_housing_capacity() - current_population
	
	if max_allowed <= 0:
		Signals.shuttle_blocked_by_population_cap.emit()
		return
	
	var colonists_to_add: int = max(min(get_shuttle_colonists(), max_allowed), 0)
	var pax := resource_manager.calculate_and_update(
		ResourceManager.ResourceType.POPULATION,
		self,
		colonists_to_add,
		ResourceEngine.ApplyTime.ON_TURN_STARTED
	)
	get_tree().get_root().get_node("World/Audio/ShuttleArrival").play()
	Signals.shuttle_arrived.emit(pax)
