class_name Player
extends CharacterBody2D

@export var default_speed:float = 300
var sprint_speed:float = default_speed * 3
var speed:float = default_speed

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	speed = default_speed
	var direction_horizontal := Input.get_axis("ui_left", "ui_right")
	var direction_vertical := Input.get_axis("ui_up", "ui_down")
	
	var move_direction := Vector2(direction_horizontal, direction_vertical).normalized()
	
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	
	if direction_horizontal:
		velocity.x = move_direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction_vertical:
		velocity.y = move_direction.y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()


func set_speed(new_speed: float ) -> void:
	speed = new_speed
