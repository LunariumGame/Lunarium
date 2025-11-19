class_name Player
extends CharacterBody2D


const JUMP_VELOCITY:float = -400.0

var speed:float = 300.0


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_horizontal := Input.get_axis("ui_left", "ui_right")
	var direction_vertical := Input.get_axis("ui_up", "ui_down")
	
	var move_direction := Vector2(direction_horizontal, direction_vertical).normalized()
	
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
