class_name EcoDome
extends Building

const PRODUCTION_TABLE := [
	0, # lvl 0 unused
	10,
	20,
	30,
]

# Power usage per level
const POWER_TABLE := [
	0, # lvl 0 unused
	10,
	15,
	20,
]


func _ready() -> void:
	Signals.turn_started_eco_dome.connect(_on_turn_started)
	Signals.turn_ended_eco_dome.connect(_on_turn_ended)
	super()


func get_power_draw() -> float:
	if current_level < POWER_TABLE.size():
		return POWER_TABLE[current_level]
	return POWER_TABLE[-1]


func _on_turn_started(_turn_number:int) -> void:
	super(_turn_number)

	if is_powered:
		resource_manager.calculate_and_update(
			ResourceManager.ResourceType.FOOD,
			self,
			_production_at_level(current_level),
			ResourceEngine.ApplyTime.ON_TURN_STARTED,
		)


func _on_turn_ended(_turn_number:int) -> void:
	super(_turn_number)


static func _production_at_level(level:int) -> float:
	if level < PRODUCTION_TABLE.size():
		return PRODUCTION_TABLE[level]
	return PRODUCTION_TABLE[-1]
