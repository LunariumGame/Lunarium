class_name TechTreeNode
extends Node2D


# Is the upgrade allowed to be purchased at this time
var unlocked: bool 
var bought: bool

@export var spec: TechTreeNodeSpec

func is_purchasable() -> bool:
	return unlocked and _resource_costs_met() and not bought


func purchase() -> bool:
	if not is_purchasable():
		return false
	
	# Subtract cost
	var cost := spec.cost
	for resource_type in cost.keys():
		var resource_cost:float = cost[resource_type]
		resource_manager.add_precalculated(resource_type, -resource_cost)
	
	# Prevent from buying again
	bought = true
	print_debug("Purchase upgraded: ", spec.name)
	
	# Activate all effects of the upgrade
	for modifier in spec.modifier_list:
		# Determine which resource this modifier applies to
		var target_type:ResourceManager.ResourceType = modifier.resource_type
		# Add it to the corresponding resource tracker’s engine
		resource_manager.add_modifier(target_type, modifier)
	
	return true

## Returns whether the player has enough resources to purchase this upgrade.
func _resource_costs_met() -> bool:
	for resource_type in spec.cost.keys():
		if spec.cost[resource_type] > resource_manager.get_resource(resource_type):
			return false
	
	return true
