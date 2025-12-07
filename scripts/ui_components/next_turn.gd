extends Button

@export var cooldown_time: float = 1.0 # seconds

var cooldown_active: bool = false

@onready var progress_bar: ProgressBar = $ProgressBar


func _ready():
	progress_bar.visible = false
	progress_bar.value = 0


func start_cooldown():
	cooldown_active = true
	progress_bar.visible = true
	progress_bar.modulate = Color(1,1,1,0.5)
	disabled = true

	var tween = get_tree().create_tween()
	tween.tween_property(progress_bar, "value", progress_bar.max_value, cooldown_time)
	tween.tween_callback(Callable(self, "_end_cooldown"))

func _end_cooldown():
	disabled = false
	progress_bar.value = 0
	progress_bar.visible = false
	cooldown_active = false
	
