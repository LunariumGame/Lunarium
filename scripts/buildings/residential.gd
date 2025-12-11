class_name Residential
extends Building

# housing capacity per level
@export var capacity_table: Array[int] = [
	0, # lvl 0 unused
	5,
	10,
	25,
]

# power draw per level
@export var power_table: Array[int] = [
	0, # lvl 0 unused
	10,
	20,
	30,
]


func _ready() -> void:
	Signals.turn_started_residential.connect(_on_turn_started)
	Signals.turn_ended_residential.connect(_on_turn_ended)
	super()


func emit_built_signal() -> void:
	Signals.building_built.emit(self)


func get_power_draw() -> float:
	if current_level < power_table.size():
		return power_table[current_level]
	return power_table[-1]


func _on_turn_started(_turn_number:int) -> void:
	super(_turn_number)


func _on_turn_ended(_turn_number:int) -> void:
	super(_turn_number)


func _get_selection_payload() -> Dictionary:
	super()
	return {
		"LEVEL": current_level,
		"POWERED": "YES" if is_powered else "NO",
		"POWER REQUIRED": int(get_power_draw()),
		"HOUSING CAPACITY": get_housing_capacity(),
		"\n": "",
		"UPGRADE COST": "MAX LEVEL" if current_level == max_level else str(int(self.building_spec.cost_levels[current_level].cost[ResourceManager.ResourceType.IRON])) + " IRON"
	}


func get_housing_capacity() -> int:
	if current_level < capacity_table.size():
		return capacity_table[current_level]
	return capacity_table[-1]
