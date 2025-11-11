class_name ResourceEngine
extends Node


enum Priority {
	# Modifiers of the same priority should be commutative
	SUBTRACTIVE_NONNEGATIVE, # Subtracts with a bound
	SUBTRACTIVE, # Subtracts without bound
	ADDITIVE, # Adds a value
	MULTIPLICATIVE, # Multiplies a value
}

enum ApplyTime {
	NOW,
	ON_TURN_END,
	ON_RESOURCE_GAIN,
	ON_BUILD,
}


var modifiers:Array[ResourceModifier] = []


## Applies the resource modifiers
func apply(value:float, apply_time: ApplyTime) -> float:
	for modifier in modifiers:
		if modifier.get_apply_time() == apply_time:
			value = modifier.apply(value)
	
	return value


func add_modifier(m:ResourceModifier) -> void:
	if m.get_apply_time() == ApplyTime.NOW:
		
		var res_type := m.get_resource_type()
		
		# Run additive gains through the modifiers
		if m.get_priority() == Priority.ADDITIVE:
			var amount = m.apply(0)
			resource_manager.calculate_and_update(res_type, amount, ApplyTime.NOW)
			return
		
		# Skip modifiers otherwise
		var current_value: float = resource_manager.get_resource(res_type)
		var new_value = m.apply(current_value)
		resource_manager.set_resource(res_type, new_value)
		
		return
	modifiers.push_back(m)
	modifiers.sort_custom(ResourceModifier.is_higher_priority)
