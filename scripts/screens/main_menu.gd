class_name MainMenuScene
extends CanvasLayer

@export var alpha_speed: float = 0.75
@export var min_alpha: float = 0.3
@export var max_alpha: float = 0.7

var _time := 0.0

@onready var rotating_moon: AnimatedSprite2D = $UIElements/MainVBox/LogoHBox/Moon/RotatingMoon
@onready var title: Sprite2D = $UIElements/MainVBox/LogoHBox/Title/LunariumTitle

func _ready() -> void:
	layer = order_man.order.MAIN_MENU
	Signals.settings_closed.connect(_on_settings_closed)
	Signals.credits_stopped_defeat.connect(_on_quit_game_pressed)


func _process(delta):
	#region Fluctuate alpha of title and rotating moon
	_time += delta * alpha_speed
	# Calculate alpha value with sine wave
	var alpha = min_alpha + (max_alpha - min_alpha) * (sin(_time) * 0.5 + 0.5)
	title.modulate = Color(title.modulate.r, title.modulate.g, title.modulate.b, alpha)
	rotating_moon.modulate = Color(rotating_moon.modulate.r, rotating_moon.modulate.g, rotating_moon.modulate.b, alpha)
	#endregion


func _on_start_game_pressed() -> void:
	close()


func _on_settings_pressed() -> void:
	Signals.settings_opened.emit()
	get_node("UIElements").visible = false


func _on_settings_closed() -> void:
	get_node("UIElements").visible = true


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func close():
	queue_free()
