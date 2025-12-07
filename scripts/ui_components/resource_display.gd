extends Label

@export var resource:ResourceManager.ResourceType:
	set(v):
		resource = v
		if is_node_ready():
			_update_display()
	get:
		return resource


func _ready() -> void:
	Signals.resource_value_changed.connect(_on_resource_value_changed)
	# for electricity usage/capacity update
	Signals.built_power_plant.connect(_on_resource_value_changed)
	Signals.built_eco_dome.connect(_on_resource_value_changed)
	Signals.built_refinery.connect(_on_resource_value_changed)
	Signals.built_residential.connect(_on_resource_value_changed)
	_update_display()


func _on_resource_value_changed() -> void:
	_update_display()


func _update_display() -> void:
	if resource == ResourceManager.ResourceType.ELECTRICITY:
		var usage := game_manager.get_electricity_usage()
		var capacity := game_manager.get_electricity_capacity()
		text = "%d / %d" % [usage, capacity]
		return
	text = "%d" % [resource_manager.get_resource(resource)]
