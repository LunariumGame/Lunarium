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
	Signals.electricity_recomputed.connect(_on_electricity_recomputed)
	_update_display()


func _on_resource_value_changed() -> void:
	_update_display()


func _on_electricity_recomputed() -> void:
	_update_display()


func _update_display() -> void:
	var cap := game_manager.get_resource_cap(resource)
	var value := resource_manager.get_resource(resource)

	# Special-case: ELECTRICITY uses usage/capacity
	if resource == ResourceManager.ResourceType.ELECTRICITY:
		var usage := game_manager.get_electricity_usage()
		text = "%d / %d" % [usage, cap]
		return

	# Special-case: POPULATION uses occupied/housing capacity
	if resource == ResourceManager.ResourceType.POPULATION:
		var housing_cap := game_manager.get_total_housing_capacity()
		text = "%d / %d" % [value, housing_cap]
		return

	# If the resource has no capacity, show only the value
	if is_nan(cap):
		text = "%d" % value
		return

	# Standard resource with capacity (e.g. food, iron, etc.)
	if inverted:
		value = cap - value
	text = "%d / %d" % [value, cap]
