class_name EcoDome
extends Building

const BASE_FOOD_PRODUCTION:int = 10


func _ready() -> void:
	super()


func get_power_draw() -> float:
	return 10


func _on_turn_started(_turn_number:int) -> void:
	super(_turn_number)
	
	if is_powered:
		resource_manager.calculate_and_update(
			ResourceManager.ResourceType.FOOD,
			self,
			BASE_FOOD_PRODUCTION,
			ResourceEngine.ApplyTime.ON_TURN_STARTED,
		)
