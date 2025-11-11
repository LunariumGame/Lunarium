class_name TechTreeNodeSpec
extends Resource


@export var cost: Dictionary = {
	ResourceManager.ResourceType.FOOD: 0,
	ResourceManager.ResourceType.ELECTRICITY: 0,
	ResourceManager.ResourceType.IRON: 0,
	ResourceManager.ResourceType.POPULATION: 0
}

@export var name: String = "New Upgrade"

@export var modifier_list: Array[Resource] = []
