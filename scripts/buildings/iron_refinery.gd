class_name IronRefinery
extends Building

const PRODUCED_RESOURCE = ResourceManager.ResourceType.IRON

var level = 1


func _ready() -> void:
	Signals.turn_started.connect(_on_turn_started)


func _on_turn_started(_turn:int) -> void:
	resource_manager.calculate_and_update(PRODUCED_RESOURCE, self, _production_at_level(level))
	print(resource_manager.get_resource(PRODUCED_RESOURCE))


static func _production_at_level(_level:int) -> float:
	return _level * 4
