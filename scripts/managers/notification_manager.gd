class_name NotificationManager
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.colonist_died.connect(_on_colonist_died)
	Signals.shuttle_arrived.connect(_on_shuttle_arrived)
	Signals.shuttle_blocked_by_population_cap.connect(_on_shuttle_blocked_by_population_cap)
	Signals.notification.connect(_debug_notification)


func _on_colonist_died(num_dead:int) -> void:
	Signals.notification.emit(Notification.new(
		"%d colonists have perished from starvation!" % num_dead,
	))


func _on_shuttle_arrived(pax:int) -> void:
	Signals.notification.emit(Notification.new(
		"%d colonists arrived on a shuttle" % pax ,
	))


func _on_shuttle_blocked_by_population_cap() -> void:
	Signals.notification.emit(Notification.new(
		"Population limit reached, you must construct additional residences!"
	))


class Notification:
	var text:String
	var icon:Texture2D
	
	
	func _init(_text:String, _icon:Texture2D = null) -> void:
		text = _text
		icon = _icon


func _debug_notification(notif:Notification) -> void:
	print_debug("Notification signal received: %s" % notif.text)
