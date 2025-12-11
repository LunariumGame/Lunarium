class_name PowerPlant
extends Building

# production rate per turn
@export var production_table: Array[int] = [
	0,  # lvl 0
	5,
	10,
	25,
]

func _ready() -> void:
	Signals.turn_started_power_plant.connect(_on_turn_started)
	Signals.turn_ended_power_plant.connect(_on_turn_ended)
	
	Signals.recompute_power_plants.connect(_compute_electricity_gen)
	is_powered = true # reactors are always powered
	super()


func emit_built_signal() -> void:
	Signals.building_built.emit(self)


func get_power_draw() -> float:
	return 0


func _on_turn_ended(_turn_number:int) -> void:
	super(_turn_number)
	_compute_electricity_gen()


func _on_turn_started(_turn_number:int) -> void:
	super(_turn_number)


func _compute_electricity_gen() -> void:
	resource_manager.calculate_and_update(
		ResourceManager.ResourceType.ELECTRICITY,
		self,
		_get_production_rate(),
		ResourceEngine.ApplyTime.ON_TURN_STARTED
	)


func _get_selection_payload() -> Dictionary:
	super()
	return {
		"\n ": "",
		"PRODUCTION": str(int(_get_production_rate())) + " ELECTRICITY",
		"\n  ": "",
		"POWER REQUIRED": int(get_power_draw()),
		"\n": "",
		"UPGRADE COST": "MAX LEVEL" if current_level == max_level else str(int(self.building_spec.cost_levels[current_level].cost[ResourceManager.ResourceType.FOOD])) + " FOOD AND " + str(int(self.building_spec.cost_levels[current_level].cost[ResourceManager.ResourceType.IRON])) + " IRON"
	}


func _get_production_rate() -> float:
	if current_level < production_table.size():
		return production_table[current_level]
	return production_table[-1]
