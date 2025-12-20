class_name EventManager
extends Node

enum Event { NONE, PARASITE, STORM, FOG, PLAGUE, HARVEST }

var event_turn_lengths: Dictionary[Event, int] = {
	Event.NONE: -1,
	Event.PARASITE: 3,
	Event.STORM: 3,
	Event.FOG: 5,
	Event.PLAGUE: 3,
	Event.HARVEST: 2
}
var current_event: Event


func _ready() -> void:
	Signals.turn_started.connect(_roll_runtime_event)
	current_event = Event.NONE


func _roll_runtime_event(_turn_number: int) -> void:
	if game_manager.state == game_manager.GameState.WON || game_manager.state == game_manager.GameState.LOST:
		# Do nothing if game was just won or lost
		return
	
	if current_event != Event.NONE:
		# If an event is already active, do nothing
		return
		
	var rand = randf()
	print("%d", rand)
	
	# 90% nothing happens, 2% for each event
	if rand < 0.9:
		print("No event triggered")
		return
	elif rand < 0.92:
		print("Parasite event triggered")
		_trigger_parasite()
	elif rand < 0.94:
		print("Electromagnetic storm event triggered")
		_trigger_storm()
	elif rand < 0.96:
		print("Fog event triggered")
		_trigger_fog()
	elif rand < 0.98:
		print("Plague event triggered")
		_trigger_plague()
	else:
		print("Harvest event triggered")
		_trigger_harvest()


func _trigger_parasite() -> void:
	pass
	

func _trigger_storm() -> void:
	pass


func _trigger_fog() -> void:
	pass


func _trigger_plague() -> void:
	pass


func _trigger_harvest() -> void:
	pass
