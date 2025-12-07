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
	Signals.built_power_plant.connect(_on_resource_value_changed)
	Signals.built_eco_dome.connect(_on_resource_value_changed)
	Signals.built_refinery.connect(_on_resource_value_changed)
	Signals.built_residential.connect(_on_resource_value_changed)
	_update_display()


func _on_resource_value_changed() -> void:
	_update_display()


func _update_display() -> void:
	var cap:float = game_manager.get_resource_cap(resource)
	var value:float = resource_manager.get_resource(resource)
	
	if is_nan(cap):
		text = "%d" % [value]
		return
	
	if inverted:
		value = cap - value
	text = "%d/%d" % [value, cap]
