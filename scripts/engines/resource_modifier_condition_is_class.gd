class_name ResourceModifierConditionIsClass
extends ResourceModifierCondition

@export var name:StringName


func is_satisfied(actor:Object, value:float) -> bool:
	if not actor:
		return false
	
	return (actor.get_class() == name) or _script_satisfies_condition_p(actor.get_script())


func _script_satisfies_condition_p(script:Script) -> bool:
	if not script:
		return false
	
	var script_name:StringName = script.get_global_name()
	if script_name == name:
		return true
	
	return _script_satisfies_condition_p(script.get_base_script())
