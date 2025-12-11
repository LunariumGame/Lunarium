extends CanvasLayer

@export var alpha_speed: float = 0.75
@export var min_alpha: float = 0.3
@export var max_alpha: float = 0.7

var _time := 0.0

@onready var title: Sprite2D = $VBoxContainer/LogoHBox/Title/LunariumTitle
@onready var rotating_moon: AnimatedSprite2D = $VBoxContainer/LogoHBox/Moon/RotatingMoon


func _ready():
	layer = order_man.order.CONTROLS
	
func _process(delta):
	#region Fluctuate alpha of title and rotating moon
	_time += delta * alpha_speed
	# Calculate alpha value with sine wave
	var alpha = min_alpha + (max_alpha - min_alpha) * (sin(_time) * 0.5 + 0.5)
	title.modulate = Color(title.modulate.r, title.modulate.g, title.modulate.b, alpha)
	rotating_moon.modulate = Color(rotating_moon.modulate.r, rotating_moon.modulate.g, rotating_moon.modulate.b, alpha)
	#endregion
	

func close():
	window_manager.pop()
	Signals.controls_closed.emit()
	queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()
