extends Control

@export var alpha_speed: float = 0.5
@export var min_alpha: float = 0.3
@export var max_alpha: float = 0.7

@onready var rotating_moon: AnimatedSprite2D = $RotatingMoon
@onready var title: Sprite2D = $LunariumTitle
@onready var master_volume: HSlider = $"AudioSettings/MasterVolume"
@onready var music_volume: HSlider = $"AudioSettings/MusicVolume"
@onready var effects_volume: HSlider = $"AudioSettings/EffectsVolume"

func _ready():
	get_parent().visible = false
	master_volume.value = 0.5
	music_volume.value = 0.5
	effects_volume.value = 0.5

func _process(delta):
	#region Fluctuate alpha of title and rotating moon
	var time := 0 
	time += delta * alpha_speed
	# Calculate alpha value with sine wave
	var alpha = min_alpha + (max_alpha - min_alpha) * (sin(time) * 0.5 + 0.5)
	title.modulate = Color(title.modulate.r, title.modulate.g, title.modulate.b, alpha)
	rotating_moon.modulate = Color(rotating_moon.modulate.r, rotating_moon.modulate.g, rotating_moon.modulate.b, alpha)
	#endregion

func _input(event):
	if event.is_action_pressed("settings"):
		get_tree().paused = !get_tree().paused
		get_parent().visible = get_tree().paused
		print(get_parent())


func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_effects_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
