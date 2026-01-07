class_name EventManager
extends Node

enum Event { NONE, PARASITE, STORM, FOG, PLAGUE, HARVEST }

var event_turn_lengths: Dictionary[Event, int] = {
	Event.NONE: -1,
	Event.PARASITE: 4,
	Event.STORM: 4,
	Event.FOG: 2,
	Event.PLAGUE: 4,
	Event.HARVEST: 3
}

var current_event: Event
var event_turns_left: int
var fog: TextureRect

func _ready() -> void:
	Signals.turn_started.connect(_handle_runtime_event)
	current_event = Event.NONE
	event_turns_left = -1
	fog = get_tree().get_root().get_node("World/Camera/Camera/FogLayer/Fog")
	fog.modulate.a = 0


func _handle_runtime_event(_turn_number: int) -> void:
	# If event is over, cancel it (we cancel at 1 to guarantee a buffer between events)
	if event_turns_left == 1:
		_cancel_event()

	# If an event is active, decrement the turns left and do nothing
	if event_turns_left > 0:
		event_turns_left -= 1
		return
	
	# Do nothing if game was just won or lost this turn
	if game_manager.state == game_manager.GameState.WON || game_manager.state == game_manager.GameState.LOST:
		return
	
	var rand = randf()
	#rand = 0.93 # TODO: this is for testing, deleteme
	
	# 85% nothing happens, 3% for each event (on next turn)
	if rand < 0.85:
		print("No event triggered")
		return
	elif rand < 0.88:
		print("Parasite event triggered")
		Signals.notification.emit(NotificationManager.Notification.new("Parasites have infested your eco-domes"))
		_trigger_parasite()
	elif rand < 0.91:
		print("Electromagnetic storm event triggered")
		Signals.notification.emit(NotificationManager.Notification.new("An electromagnetic storm has begun"))
		_trigger_storm()
	elif rand < 0.94:
		print("Fog event triggered")
		Signals.notification.emit(NotificationManager.Notification.new("Methane fog has covered the surface"))
		_trigger_fog()
	elif rand < 0.97:
		print("Plague event triggered")
		Signals.notification.emit(NotificationManager.Notification.new("A deadly plague has hit your colonists"))
		_trigger_plague()
	else:
		print("Harvest event triggered")
		Signals.notification.emit(NotificationManager.Notification.new("The soil is rich, a harvest begins"))
		_trigger_harvest()


func _cancel_event() -> void:
	_reset_effects()
	current_event = Event.NONE


func _reset_effects() -> void:
	fade_fog(0.0, 1.0)
	#TODO


## Takes in opacity (0 is off), and duration of the fade
func fade_fog(opacity: float, duration: float) -> void:
	fog.visible = true
	var t = create_tween()
	t.tween_property(fog, "modulate:a", opacity, duration)
	if opacity == 0:
		t.finished.connect(hide_fog)


func hide_fog() -> void:
	fog.visible = false


func _trigger_parasite() -> void:
	event_turns_left = event_turn_lengths[Event.PARASITE]
	pass
	

func _trigger_storm() -> void:
	event_turns_left = event_turn_lengths[Event.STORM]
	pass


func _trigger_fog() -> void:
	event_turns_left = event_turn_lengths[Event.FOG]
	fade_fog(1.0, 3.0)


func _trigger_plague() -> void:
	event_turns_left = event_turn_lengths[Event.PLAGUE]
	pass


func _trigger_harvest() -> void:
	event_turns_left = event_turn_lengths[Event.HARVEST]
	pass
