class_name CameraController
extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.3
@export var max_zoom: float = 5.0

@export var sprint_speed_scale: float = 3.0

@export var set_max_shake: float = 3.0
@export var shake_fade: float = 3.0

var _curr_shake_strength: float = 0.0
var max_shake: float
var default_cam_speed: float
var sprint_speed: float
var cur_speed: float

@onready var fog: TextureRect = $FogLayer/Fog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_shake = set_max_shake


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	# Ensure speed is up to date with settings
	default_cam_speed = settings_data.default_speed * clamp(1 / zoom.x, 1, 3)
	cur_speed = default_cam_speed
	
	if Input.is_action_pressed("sprint"):
		cur_speed *= sprint_speed_scale
		
	if direction != Vector2.ZERO:
		global_position += direction * cur_speed * _delta
		clamp_camera()

	# Handle any camera shake if present
	if _curr_shake_strength > 0:
		_curr_shake_strength = lerp(_curr_shake_strength, 0.0, shake_fade * _delta)
		offset = Vector2(randf_range(-_curr_shake_strength, _curr_shake_strength), randf_range(-_curr_shake_strength, _curr_shake_strength))


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
		#fog.texture.noise.frequency = 0.0063 * (1 / zoom.x) # NOTE: can experiment with this to adjust fog based on zoom level

	# Click and drag camera
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			global_position -= event.relative / zoom
			clamp_camera()


func trigger_shake() -> void:
	_curr_shake_strength = max_shake


func toggle_camera_shake(shake_on:bool) -> void:
	# enable
	if shake_on:
		max_shake = set_max_shake
	else: # disable
		max_shake = 0


# Keeps the camera in limits
func clamp_camera() -> void:
	var half_view := get_viewport_rect().size * 0.5 * (Vector2(1,1) / zoom)
	global_position.x = clampf(global_position.x, self.limit_left + half_view.x, self.limit_right - half_view.x)
	global_position.y = clampf(global_position.y, self.limit_top + half_view.y, self.limit_bottom - half_view.y)
