class_name Residential
extends Building

# Housing capacity per level
const CAPACITY_TABLE := [
	0, # lvl 0 unused
	20,
	40,
	80,
]

# Power usage per level
const POWER_TABLE := [
	0, # lvl 0 unused
	10,
	15,
	20,
]


func _ready() -> void:
	Signals.turn_started_residential.connect(_on_turn_started)
	Signals.turn_ended_residential.connect(_on_turn_ended)
	super()


func emit_built_signal() -> void:
	Signals.building_built.emit(self)


func get_power_draw() -> float:
	if current_level < POWER_TABLE.size():
		return POWER_TABLE[current_level]
	return POWER_TABLE[-1]


func _on_turn_started(_turn_number:int) -> void:
	super(_turn_number)


func _on_turn_ended(_turn_number:int) -> void:
	super(_turn_number)


func _get_selection_payload() -> Dictionary:
	return {
		"Level": current_level,
		"Housing Capacity": get_housing_capacity(),
	}


func get_housing_capacity() -> int:
	if current_level < CAPACITY_TABLE.size():
		return CAPACITY_TABLE[current_level]
	return CAPACITY_TABLE[-1]
