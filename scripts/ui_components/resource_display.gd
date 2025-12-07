extends Label

@export var resource:ResourceManager.ResourceType:
	set(v):
		resource = v
		if is_node_ready():
			_update_display()
	get:
		return resource

@export var inverted:bool = false:
	set(v):
		inverted = v
		if is_node_ready():
			_update_display()

func _ready() -> void:
	Signals.resource_value_changed.connect(_on_resource_value_changed)
	# for electricity usage/capacity update
	Signals.building_built.connect(_on_building_built)
	_update_display()


func _on_resource_value_changed() -> void:
	_update_display()


func _on_building_built(building: Node) -> void:
	_update_display()


func _update_display() -> void:
	var cap:float = game_manager.get_resource_cap(resource)
	var value:float = resource_manager.get_resource(resource)
	
	if is_nan(cap):
		text = "%d" % [value]
		return
	if resource == ResourceManager.ResourceType.POPULATION:
		var population := resource_manager.get_resource(ResourceManager.ResourceType.POPULATION)
		var housing_capacity := game_manager.get_total_housing_capacity()
		text = "%d / %d" % [population, housing_capacity]
		return
	text = "%d" % [resource_manager.get_resource(resource)]
	
	if inverted:
		value = cap - value
	text = "%d/%d" % [value, cap]
