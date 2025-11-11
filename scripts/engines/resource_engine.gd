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
func apply(actor:Node, value:float, apply_time: ApplyTime) -> float:
	for modifier in modifiers:
		if modifier.get_apply_time() == apply_time:
			value = modifier.apply(actor, value)
	
	return value


func add_modifier(m:ResourceModifier) -> void:
	modifiers.push_back(m)
	modifiers.sort_custom(ResourceModifier.is_higher_priority)
