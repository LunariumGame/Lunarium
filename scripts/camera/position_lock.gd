class_name PositionLock
extends Camera2D


@export var player:CharacterBody2D
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.3
@export var max_zoom: float = 5.0
@export var set_max_shake: float = 5.0
@export var shake_fade: float = 5.0

var _curr_shake_strength: float = 0.0
var drag_offset := Vector2.ZERO
var max_shake: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_shake = set_max_shake
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var ppos:Vector2 = player.global_position
	
	global_position = ppos + drag_offset
	
	if _curr_shake_strength > 0:
		_curr_shake_strength = lerp(_curr_shake_strength, 0.0, shake_fade * _delta)
		offset = Vector2(randf_range(-_curr_shake_strength, _curr_shake_strength), randf_range(-_curr_shake_strength, _curr_shake_strength))


func trigger_shake() -> void:
	_curr_shake_strength = max_shake


func toggle_camera_shake() -> void:
	# enable
	if max_shake > 0:
		max_shake = set_max_shake
	else: # disable
		max_shake = 0


# Camera zoom and click-drag
func _unhandled_input(event):
	# Zoom camera
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_speed, zoom_speed)

		# clamp so zoom never becomes too large or tiny
		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)

	# Click and drag camera
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			drag_offset -= event.relative / zoom
