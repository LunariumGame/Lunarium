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
	ON_TURN_STARTED,
	ON_TURN_END,
	ON_RESOURCE_GAIN,
	ON_BUILD,
}


var modifiers:Array[ResourceModifier] = []


# Applies all resource modifiers of equal apply_time to a value and returns the new value
func apply(actor:Object, value:float, apply_time: ApplyTime) -> float:
	for modifier in modifiers:
		if modifier.get_apply_time() == apply_time:
			
			# basic_resource_modifier's apply takes the value parameter and uses the 
			# stored priority/amount in the mod to update it
			value = modifier.apply(actor, value)
	
	return value


# If the modifier is to happen now, use it and forget it
# Otherwise, adds the modifier to the list of modifiers for this specific resource
# and the specified apply time
func add_modifier(m:ResourceModifier) -> void:
	# Do not add immediate modifiers 
	if m.get_apply_time() == ApplyTime.NOW:
		
		var resource_type := m.get_resource_type()
		
		# Run additive gains through the modifiers
		if m.get_priority() == Priority.ADDITIVE:
			var amount = m.apply(null, 0)
			resource_manager.calculate_and_update(resource_type, null, amount, ApplyTime.NOW)
			return
		
		# Skip modifiers otherwise
		var current_value: float = resource_manager.get_resource(resource_type)
		var new_value = m.apply(null, current_value)
		resource_manager.set_resource(resource_type, new_value)
		
		return
	
	modifiers.push_back(m)
	modifiers.sort_custom(ResourceModifier.is_higher_priority)
