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

var is_blackout: bool = false


func _ready() -> void:
	# turn end, build, upgrade
	Signals.resource_value_changed.connect(_update_display)
	# electricity usage/capacity change
	Signals.electricity_recomputed.connect(_update_display)
	# upgrades
	Signals.building_stats_changed.connect(_update_display)
	_update_display()


func _update_display() -> void:
	var cap := game_manager.get_resource_cap(resource)
	var value := resource_manager.get_resource(resource)

	# Special-case: ELECTRICITY uses usage/capacity
	if resource == ResourceManager.ResourceType.ELECTRICITY:
		var usage := game_manager.get_electricity_usage()
		text = "%d / %d" % [usage, cap]
		
		if is_blackout and usage == cap:
				is_blackout = false
	

		if usage > cap:
			if not is_blackout:
				get_tree().get_root().get_node("World/Audio/PowerOff").play()
				is_blackout = true
			modulate = Color.RED
		else:
			
			#get_tree().get_root().get_node("World/Audio/PowerOn").play()
			modulate = Color.WHITE
			
		return


	# Special-case: POPULATION uses occupied/housing capacity
	if resource == ResourceManager.ResourceType.POPULATION:
		var housing_cap := game_manager.get_total_housing_capacity()
		text = "%d/%d" % [value, housing_cap + 1] # plus 1 for starting colonist
		return

	# If the resource has no capacity, show only the value
	if is_nan(cap):
		text = "%d" % value
		return

	# Standard resource with capacity (e.g. food, iron, etc.)
	if inverted:
		value = cap - value
	text = "%d/%d" % [value, cap]
