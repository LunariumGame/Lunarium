class_name TechTreeNodeSpec
extends Resource


@export var name: String = "New Upgrade"

# An integer that describes how difficult it should be to unlock this upgrade
# Range is based on tech_tree_manager's const MAX_TIER
@export_range(1, 10) 
var tier: int = 1

@export var cost: Dictionary[ResourceManager.ResourceType, float] = {
	ResourceManager.ResourceType.FOOD: 0,
	ResourceManager.ResourceType.ELECTRICITY: 0,
	ResourceManager.ResourceType.IRON: 0,
	ResourceManager.ResourceType.POPULATION: 0
}

@export var modifier_list: Array[ResourceModifier] = []
