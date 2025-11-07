extends CanvasLayer

@export var alpha_speed: float = 0.75
@export var min_alpha: float = 0.3
@export var max_alpha: float = 0.7

var _time := 0.0

@onready var rotating_moon: AnimatedSprite2D = $Settings/RotatingMoon
@onready var title: Sprite2D = $Settings/LunariumTitle
@onready var master_volume: HSlider = $"Settings/AudioSettings/MasterVolume"
@onready var music_volume: HSlider = $"Settings/AudioSettings/MusicVolume"
@onready var effects_volume: HSlider = $"Settings/AudioSettings/EffectsVolume"

func _ready():
	master_volume.value = settings_data.volume_value_master
	music_volume.value = settings_data.volume_value_music
	effects_volume.value = settings_data.volume_value_effects

	get_tree().paused = true

func close():
	get_tree().paused = false
	window_manager.pop()
	queue_free()

func _process(delta):
	#region Fluctuate alpha of title and rotating moon
	_time += delta * alpha_speed
	# Calculate alpha value with sine wave
	var alpha = min_alpha + (max_alpha - min_alpha) * (sin(_time) * 0.5 + 0.5)
	title.modulate = Color(title.modulate.r, title.modulate.g, title.modulate.b, alpha)
	rotating_moon.modulate = Color(rotating_moon.modulate.r, rotating_moon.modulate.g, rotating_moon.modulate.b, alpha)
	#endregion


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()
	
	#if event.is_action_pressed("settings"):
		#get_tree().paused = !get_tree().paused
		#get_parent().visible = get_tree().paused
		#print(get_parent())


func _on_master_volume_value_changed(value: float) -> void:
	settings_data.volume_value_master = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_volume_value_changed(value: float) -> void:
	settings_data.volume_value_music = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_effects_volume_value_changed(value: float) -> void:
	settings_data.volume_value_effects = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_quit_game_pressed() -> void:
	get_tree().quit()
