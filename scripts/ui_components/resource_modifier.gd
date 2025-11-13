@abstract
class_name ResourceModifier
extends Resource

@abstract func apply(actor:Object, value:float) -> float

## Returns the priority of the modifier
## Higher priority modifiers get applied first
@abstract func get_priority() -> ResourceEngine.Priority

@abstract func get_apply_time() -> ResourceEngine.ApplyTime

@abstract func get_resource_type() -> ResourceManager.ResourceType

static func is_higher_priority(a:ResourceModifier, b:ResourceModifier) -> bool:
	return a.get_priority() > b.get_priority()
