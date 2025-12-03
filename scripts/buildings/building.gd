class_name Building
extends Node2D


@export var building_spec: BuildingSpec
@export var max_level: int


var is_powered:bool
var current_level:int = 1


func _ready() -> void:
	Signals.turn_started.connect(_on_turn_started)
	Signals.turn_ended.connect(_on_turn_ended)


func get_power_draw() -> float:
	return 0


## Overriding implementations should call super() at the beginning .
func _on_turn_started(_turn_number:int) -> void:
	var power_draw:float = get_power_draw()
	var available_electricity:float = resource_manager.get_resource(
			ResourceManager.ResourceType.ELECTRICITY)
	
	is_powered = power_draw <= available_electricity
	if is_powered:
		resource_manager.add_precalculated(
				ResourceManager.ResourceType.ELECTRICITY, -power_draw)


## Overriding implementations should call super() at the beginning .
func _on_turn_ended(_turn_number:int) -> void:
	pass


func get_build_cost() -> Cost:
	return get_upgrade_cost(1)


## Level 1 = build cost, level 2 = level 2
func get_upgrade_cost(level: int) -> Cost:
	
	if level <= 0 or level > max_level:
		return null
	
	if level > building_spec.cost.size():
		printerr("You need to add a cost for level ", level, " on building ", self.name)
		return null
	
	return building_spec.cost[level - 1]


func get_type() -> BuildingManager.BuildingType:
	return building_spec.type
