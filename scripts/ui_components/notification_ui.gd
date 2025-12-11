class_name NotificationUI
extends PanelContainer

@onready var label: Label = $Label
@onready var notif_sound: AudioStreamPlayer = $NotifSound


enum State {
	IDLE,
	TYPING,
	SHOWING,
}

var nq:Array[NotificationManager.Notification] = []
var state:State = State.IDLE
var typing_time:float = 0.0
var shown_for:float = 0.0
var current:NotificationManager.Notification = null
var cpm:float = 1200
var show_duration:float = 3

func _ready() -> void:
	Signals.notification.connect(_on_notification)
	visible = false
	modulate.a = 1.0


func _on_notification(n:NotificationManager.Notification) -> void:
	nq.append(n)


func _process(delta: float) -> void:
	match state:

		State.IDLE:
			# If currently has no notif but queue has more, load the next one
			if current == null and not nq.is_empty():
				current = nq.pop_front()
				_start_typing()

		State.TYPING:
			typing_time += delta
			var total_chars := current.text.length()
			var typed_chars := int(typing_time * cpm / 60.0)

			label.text = current.text.substr(0, min(typed_chars, total_chars))

			if typed_chars >= total_chars:
				_start_showing()

		State.SHOWING:
			shown_for += delta
			if shown_for >= show_duration:
				_start_fade_out()


func _start_typing() -> void:
	state = State.TYPING
	typing_time = 0.0
	label.text = ""
	visible = true
	modulate.a = 1.0
	if not notif_sound.playing:
		notif_sound.play()


func _start_showing() -> void:
	state = State.SHOWING
	shown_for = 0.0
	notif_sound.stop()


func _start_fade_out() -> void:
	state = State.IDLE
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.4)
	t.finished.connect(_on_fade_done)


func _on_fade_done() -> void:
	visible = false
	modulate.a = 1.0
	current = null
