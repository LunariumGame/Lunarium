class_name TechTreeNode
extends Node2D


# Is the upgrade allowed to be purchased at this time
var unlocked: bool 
var bought: bool

@export var spec: TechTreeNodeSpec


func purchase() -> void:
	if bought or not unlocked:
		return;
	
	# Subtract cost
	var cost := spec.cost
	for resource_type in cost.keys():
		var resource_cost = cost[resource_type]
		resource_manager.add_precalculated(resource_type, -resource_cost)
	
	# Prevent from buying again
	bought = true
	print_debug("Purchase upgraded: ", spec.name)
	
	# Activate all effects of the upgrade
	for modifier in spec.modifier_list:
		if modifier is ResourceModifier:
			# Determine which resource this modifier applies to
			var target_type = modifier.resource_type
			# Add it to the corresponding resource tracker’s engine
			resource_manager._trackers[target_type].engine.add_modifier(modifier)
		else:
			printerr("Invalid upgrade type in ", spec.name)
			
