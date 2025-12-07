class_name PowerPlant
extends Building

const PRODUCTION_TABLE := [
	0,   # lvl 0 unused
	10,
	20,
	30,
]


func _ready() -> void:
	Signals.turn_started_power_plant.connect(_on_turn_started)
	Signals.turn_ended_power_plant.connect(_on_turn_ended)
	super()


func emit_built_signal() -> void:
	Signals.building_built.emit(self)


func get_power_draw() -> float:
	return 0


func _on_turn_started(_turn_number:int) -> void:
	super(_turn_number)

	resource_manager.calculate_and_update(
		ResourceManager.ResourceType.ELECTRICITY,
		self,
		_get_production_rate(),
		ResourceEngine.ApplyTime.ON_TURN_STARTED
	)


func _on_turn_ended(_turn_number:int) -> void:
	super(_turn_number)


func _get_selection_payload() -> Dictionary:
	return {
		"Level": current_level,
		"Power Production": str(_get_production_rate()) + "kW",
	}


func _get_production_rate() -> float:
	if current_level < PRODUCTION_TABLE.size():
		return PRODUCTION_TABLE[current_level]
	return PRODUCTION_TABLE[-1]
