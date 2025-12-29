extends CanvasLayer

@export var scroll_speed : float = 45

@onready var credit_text := $Credits
@onready var black_box: ColorRect = $ColorRect
@onready var embark := $Embark


func _ready() -> void:
	print("credits called")
	embark.play()
	
	# Make credits invisible at first
	black_box.modulate.a = 0.0
	credit_text.modulate.a = 0.0
	# Fade in over 1 second
	var tween = create_tween()
	tween.tween_property(black_box, "modulate:a", 1.0, 3.0)
	tween.tween_property(credit_text, "modulate:a", 1.0, 3.0)


func _process(delta: float) -> void:
	credit_text.global_position += Vector2(0, -(delta * scroll_speed))


# called when "continue" button is clicked
func close() -> void:
	window_manager.pop()
	queue_free()
