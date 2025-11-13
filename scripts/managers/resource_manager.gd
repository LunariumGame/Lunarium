class_name ResourceManager
extends Node

enum ResourceType {
	FOOD,
	ELECTRICITY,
	IRON,
	POPULATION,
}

var _trackers:Dictionary[ResourceType, ResourceTracker]


func _ready() -> void:
	_trackers = {
		ResourceType.FOOD: ResourceTracker.new(100),
		ResourceType.ELECTRICITY: ResourceTracker.new(),
		ResourceType.IRON: ResourceTracker.new(100),
		ResourceType.POPULATION: ResourceTracker.new(1),
	}
	
	for type in ResourceType.values():
		assert(type in _trackers, "%s not in _trackers" % ResourceType.keys()[type])
	


func get_resource(resource_type:ResourceType) -> float:
	return _trackers[resource_type].value


func set_resource(resource_type:ResourceType, value:float) -> void:
	_trackers[resource_type].value = value
	Signals.resource_value_changed.emit(resource_type, get_resource(resource_type))


## Applies modifiers to value before adding the value to the resource.
func calculate_and_update(resource_type:ResourceType, actor:Object, value:float, apply_time: ResourceEngine.ApplyTime) -> float:
	var modified_value:float = calculate_modifiers(resource_type, actor, value, apply_time)
	add_precalculated(resource_type, modified_value)
	# resource_value_changed is already emitted by add_precalculated
	return modified_value


## Add a precalcualted value to the resource, skipping any modifier calculations
func add_precalculated(resource_type:ResourceType, value:float) -> void:
	_trackers[resource_type].add_precalculated(value)
	Signals.resource_value_changed.emit(resource_type, get_resource(resource_type))


## Calculates gain/loss value with modifiers applied
##
## Does not update the value of the resource.
func calculate_modifiers(resource_type:ResourceType, actor:Object, value:float, apply_time: ResourceEngine.ApplyTime) -> float:
	return _trackers[resource_type].engine.apply(actor, value, apply_time)


class ResourceTracker:
	var value:float
	var engine:ResourceEngine
	
	func _init(_value:float = 0, _engine:ResourceEngine = null) -> void:
		value = _value
		engine = _engine if _engine else ResourceEngine.new()
	
	func add_precalculated(_value:float) -> void:
		value += _value
