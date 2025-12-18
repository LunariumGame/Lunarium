extends CanvasLayer

@onready var credits := $Control


func _ready() -> void:
	print("credits called")
	
	# Make credits invisible at first
	credits.modulate.a = 0.0
	# Fade in over 1 second
	var tween = create_tween()
	tween.tween_property(credits, "modulate:a", 1.0, 3.0)


# called when "continue" button is clicked
func close():
	window_manager.pop()
	queue_free()
