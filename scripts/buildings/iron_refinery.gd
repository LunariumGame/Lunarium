class_name IronRefinery
extends Building

# production rate per turn
@export var production_table: Array[int] = [
	0,  # lvl 0
	3,
	5,
	25,
]

# power draw per level
@export var power_table: Array[int] = [
	0,  # lvl 0
	5,
	15,
	30,
]

func _ready() -> void:
	Signals.turn_started_refinery.connect(_on_turn_started)
	Signals.turn_ended_refinery.connect(_on_turn_ended)
	super()


func emit_built_signal() -> void:
	Signals.building_built.emit(self)


func get_power_draw() -> float:
	if current_level < power_table.size():
		return power_table[current_level]
	return power_table[-1]


func _on_turn_ended(_turn_number:int) -> void:
	super(_turn_number)


func _on_turn_started(_turn_number:int) -> void:
	if is_powered:
		resource_manager.calculate_and_update(
			ResourceManager.ResourceType.IRON,
			self,
			_get_production_rate(),
			ResourceEngine.ApplyTime.ON_TURN_STARTED
		)


func _get_selection_payload() -> Dictionary:
	super()
	return {
		"\n ": "",
		"PRODUCTION": str(int(_get_production_rate())) + " IRON PER TURN",
		"\n  ": "",
		"POWER REQUIRED": int(get_power_draw()),
		"POWERED": "YES" if is_powered else "NO",
		"\n": "",
		"UPGRADE COST": "MAX LEVEL" if current_level == max_level else str(int(self.building_spec.cost_levels[current_level].cost[ResourceManager.ResourceType.FOOD])) + " FOOD AND " + str(int(self.building_spec.cost_levels[current_level].cost[ResourceManager.ResourceType.IRON])) + " IRON"
	}


func _get_production_rate() -> float:
	if current_level < production_table.size():
		return production_table[current_level]
	return production_table[-1]
