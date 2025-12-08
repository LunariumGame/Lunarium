class_name IronRefinery
extends Building

# production rate per turn
@export var production_table: Array[int] = [
	0,  # lvl 0
	4,
	8,
	12,
]

# power draw per level
@export var power_table: Array[int] = [
	0,  # lvl 0
	10,
	15,
	20,
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
	return {
		"LEVEL": current_level,
		"POWERED": "YES" if is_powered else "NO",
		"POWER REQUIRED": get_power_draw(),
		"PRODUCTION": str(int(_get_production_rate())) + " IRON PER TURN",
	}


func _get_production_rate() -> float:
	if current_level < production_table.size():
		return production_table[current_level]
	return production_table[-1]
