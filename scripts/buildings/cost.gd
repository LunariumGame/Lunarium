class_name Cost
extends Resource


@export var cost: Dictionary[ResourceManager.ResourceType, float] = {
	ResourceManager.ResourceType.FOOD: 0,
	ResourceManager.ResourceType.ELECTRICITY: 0,
	ResourceManager.ResourceType.IRON: 0,
	ResourceManager.ResourceType.POPULATION: 0
}
