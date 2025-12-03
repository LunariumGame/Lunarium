class_name IronRefinery
extends Building

const PRODUCED_RESOURCE := ResourceManager.ResourceType.IRON


func _ready() -> void:
	super()


func _on_turn_started(turn:int) -> void:
	super(turn)
	resource_manager.calculate_and_update(PRODUCED_RESOURCE, self, _production_at_level(current_level), ResourceEngine.ApplyTime.ON_TURN_STARTED)
	print(resource_manager.get_resource(PRODUCED_RESOURCE))


static func _production_at_level(_level:int) -> float:
	return _level * 4
