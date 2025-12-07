extends Node

const BASE_TURNS_BETWEEN_SHUTTLES:int = 5

@export var colonists_per_shuttle:int = 20

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
	return colonists_per_shuttle


func _process_shuttle_arrival() -> void:
	Signals.shuttle_arrived.emit()
	resource_manager.calculate_and_update(
		ResourceManager.ResourceType.POPULATION,
		self,
		get_shuttle_colonists(),
		ResourceEngine.ApplyTime.ON_TURN_STARTED)
