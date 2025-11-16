@abstract
class_name Building
extends Node2D

var is_powered:bool


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
