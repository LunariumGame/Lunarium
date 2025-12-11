class_name HeadQuarters
extends Building


# production rate per turn
@export var iron_per_turn: int = 1


func _ready() -> void:
	Signals.turn_ended.connect(_on_turn_ended)
	is_powered = true # HQ always powered
	super()


func _on_turn_ended(_turn_number:int) -> void:
	resource_manager.calculate_and_update(
		ResourceManager.ResourceType.IRON,
		self,
		iron_per_turn,
		ResourceEngine.ApplyTime.ON_TURN_STARTED
	)

func _get_selection_payload() -> Dictionary:
	super()
	return {
		"POWERED": "YES" if is_powered else "NO",
		"POWER REQUIRED": int(get_power_draw()),
		"PRODUCTION": str(iron_per_turn) + " IRON PER TURN",
		"\n": "",
	}
