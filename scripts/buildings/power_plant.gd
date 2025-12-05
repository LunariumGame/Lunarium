class_name PowerPlant
extends Building

const BASE_POWER_GENERATION:float = 30


func _ready() -> void:
	super()


func _on_turn_started(_turn_number:int) -> void:
	super(_turn_number)
	
	resource_manager.calculate_and_update(
			ResourceManager.ResourceType.ELECTRICITY,
			self,
			BASE_POWER_GENERATION,
			ResourceEngine.ApplyTime.ON_TURN_STARTED)
