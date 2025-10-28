class_name ResourceEngine
extends Node


@abstract class ResourceModifier:
	enum Priority {
		# Modifiers of the same priority should be commutative
		SUBTRACTIVE_NONNEGATIVE, # Subtracts with a bound
		SUBTRACTIVE, # Subtracts without bound
		ADDITIVE, # Adds a value
		MULTIPLICATIVE, # Multiplies a value
	}
	
	@abstract func apply(actor:Node, value:float) -> float
	
	
	## Returns the priority of the modifier
	## Higher priority modifiers get applied first
	@abstract func priority() -> Priority
	
	
	static func is_higher_priority(a:ResourceModifier, b:ResourceModifier) -> bool:
		return a.priority() > b.priority()


var modifiers:Array[ResourceModifier] = []


## Applies the resource modifiers
func apply(actor:Node, value:float) -> float:
	for modifier in modifiers:
		value = modifier.apply(actor, value)
	
	return value


func add_modifier(m:ResourceModifier) -> void:
	modifiers.push_back(m)
	modifiers.sort_custom(ResourceModifier.is_higher_priority)
