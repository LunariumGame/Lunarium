extends CanvasLayer

@export var alpha_speed: float = 0.75
@export var min_alpha: float = 0.3
@export var max_alpha: float = 0.7

var _time := 0.0
var hud : CanvasLayer 

@onready var rotating_moon: AnimatedSprite2D = $Settings/MainVBox/LogoHBox/Moon/RotatingMoon
@onready var title: Sprite2D = $Settings/MainVBox/LogoHBox/Title/LunariumTitle
@onready var master_volume: HSlider = $"Settings/MainVBox/AudioSettings/MasterVolume"
@onready var music_volume: HSlider = $"Settings/MainVBox/AudioSettings/MusicVolume"
@onready var effects_volume: HSlider = $"Settings/MainVBox/AudioSettings/EffectsVolume"
@onready var ui_scale: HSlider = $"Settings/MainVBox/UISettings/ScaleSlider"
@onready var cam_speed_scale: HSlider = $"Settings/MainVBox/CameraSettings/CameraSpeed"
@onready var rb_curs_checkbox: CheckBox = $"Settings/CheckBox"
@onready var master_default_db_vol := AudioServer.get_bus_volume_db(0)
@onready var how_to_play_center: CenterContainer = $Settings/MainVBox/Buttons/HowToPlayCenter

func _ready():
	layer = order_man.order.SETTINGS
	master_volume.value = settings_data.volume_value_master
	music_volume.value = settings_data.volume_value_music
	effects_volume.value = settings_data.volume_value_effects
	ui_scale.value = settings_data.scale_value
	cam_speed_scale.value = settings_data.default_speed
	rb_curs_checkbox.button_pressed = settings_data.rb_cursor_enabled
	
	
	hud = get_tree().get_root().get_node("World/UI/HUD")
	hud.visible = false
	get_tree().paused = true


func close():
	get_tree().paused = false
	hud.visible = true
	window_manager.pop()
	Signals.settings_closed.emit()
	queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()


func _process(delta):
	#region Fluctuate alpha of title and rotating moon
	_time += delta * alpha_speed
	# Calculate alpha value with sine wave
	var alpha = min_alpha + (max_alpha - min_alpha) * (sin(_time) * 0.5 + 0.5)
	title.modulate = Color(title.modulate.r, title.modulate.g, title.modulate.b, alpha)
	rotating_moon.modulate = Color(rotating_moon.modulate.r, rotating_moon.modulate.g, rotating_moon.modulate.b, alpha)
	#endregion
	how_to_play_center.visible = (GameState.state == GameState.State.PLAYING)


func _on_master_volume_value_changed(value: float) -> void:
	settings_data.volume_value_master = value
	var db = linear_to_db(value) + master_default_db_vol
	AudioServer.set_bus_volume_db(0, db)


func _on_music_volume_value_changed(value: float) -> void:
	settings_data.volume_value_music = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_effects_volume_value_changed(value: float) -> void:
	settings_data.volume_value_effects = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_scale_slider_value_changed(value: float) -> void:
	settings_data.scale_value = value
	UiScaleManager.scale = value


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	close()


func _on_camera_speed_value_changed(value: float) -> void:
	settings_data.default_speed = value


# turn cursor to rainbow mode
func _on_check_box_toggled(toggled_on: bool) -> void:
	var cursor: SubViewport = get_tree().get_root().get_node("World/Cursor")
	cursor.enable_rainbow = toggled_on
	settings_data.rb_cursor_enabled = toggled_on


func _on_button_pressed() -> void:
	Signals.toggle_tutorial.emit()
	close()
