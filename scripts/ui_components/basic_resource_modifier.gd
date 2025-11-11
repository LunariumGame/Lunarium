class_name BasicResourceModifier
extends ResourceModifier


@export var resource_type: ResourceManager.ResourceType
@export var amount: float
@export var priority: ResourceEngine.Priority
@export var apply_time: ResourceEngine.ApplyTime


# The resource engine handles apply time 
func apply(value:float) -> float:
	match priority:
		ResourceEngine.Priority.SUBTRACTIVE_NONNEGATIVE:
			value -= amount
			if value < 0:
				value = 0
		ResourceEngine.Priority.SUBTRACTIVE:
			value -= amount
		ResourceEngine.Priority.ADDITIVE:
			value += amount
		ResourceEngine.Priority.MULTIPLICATIVE:
			value *= amount
	return value


func get_priority() -> ResourceEngine.Priority:
	return priority


func get_apply_time() -> ResourceEngine.ApplyTime:
	return apply_time


func get_resource_type() -> ResourceManager.ResourceType:
	return resource_type
