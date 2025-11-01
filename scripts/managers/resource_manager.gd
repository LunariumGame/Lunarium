class_name ResourceManager
extends Node

enum ResourceType {
	FOOD,
	ELECTRICITY,
	IRON,
	POPULATION,
}

var resources:Dictionary[ResourceType, float]
var engines:Dictionary[ResourceType, ResourceEngine]


func _ready() -> void:
	resources = {
		ResourceType.FOOD: 100,
		ResourceType.ELECTRICITY: 100,
		ResourceType.IRON: 100,
		ResourceType.POPULATION: 100,
	}
	
	for type in ResourceType:
		assert(type in resources)
	
	for type in ResourceType:
		engines[type] = ResourceEngine.new()


## Calculates gain/loss value with modifiers applied
##
## Does not update the value of the resource.
func calculate_modifiers(actor:Node, value:float, resource_type:ResourceType) -> float:
	return engines[resource_type].apply(actor, value)
	
	
