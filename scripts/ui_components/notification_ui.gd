class_name NotificationUI
extends PanelContainer

@onready var label: Label = $Label
@onready var notification_interval: Timer = $NotificationInterval


enum State {
	IDLE,
	TYPING,
	SHOWING,
}

var notification_queue:Array[NotificationManager.Notification] = []
var state:State
var typing_time:float
var shown_for:float

var cpm:float = 1500
var show_duration:float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.notification.connect(_on_notification)


func _on_notification(n:NotificationManager.Notification) -> void:
	notification_queue.append(n)


func _process(delta:float) -> void:
	match state:
		State.IDLE:
			visible = false
			if not notification_queue.is_empty():
				typing_time = 0
				state = State.TYPING
		
		State.TYPING:
			visible = true
			typing_time += delta
			var typed_chars:int = floori(typing_time * cpm / 60)
			var len:int = notification_queue[0].text.length()
			label.text = notification_queue[0].text.substr(0, min(typed_chars, len))
			
			if typed_chars >= len:
				shown_for = 0
				state = State.SHOWING
		
		State.SHOWING:
			shown_for += delta
			
			if shown_for >= show_duration:
				notification_queue.pop_front()
				state = State.IDLE
