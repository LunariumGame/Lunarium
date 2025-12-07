# not abstract: otherwise children cannot invoke parent methods, or use super()
class_name Building
extends Node2D


@export var building_spec: BuildingSpec
@export var max_level: int
# NOTE: scale all inherited building sprites here across the entire game
@export var building_scale := Vector2(4, 4)

@export var outline_color: Color = Color(0.0, 0.0, 0.0, 0.5)
@export var outline_thickness: float = 2.0

@onready var clickable_area: Area2D = $Area2D

var is_cursor: bool = false

var building_id: int = -1
var is_powered: bool
var current_level: int = 1


func _ready() -> void:
	Signals.turn_started.connect(_on_turn_started)
	Signals.turn_ended.connect(_on_turn_ended)
	clickable_area.input_event.connect(_on_Area2D_input_event)
	scale = building_scale
	z_index = order_man.order.BUILDINGS
	queue_redraw()


func get_power_draw() -> float:
	return 0


## Overriding implementations should call super() at the beginning
func _on_turn_started(_turn_number:int) -> void:
	var power_draw:float = self.get_power_draw()
	var available_electricity:float = resource_manager.get_resource(
			ResourceManager.ResourceType.ELECTRICITY)
	
	is_powered = power_draw <= available_electricity
	if is_powered:
		resource_manager.add_precalculated(
				ResourceManager.ResourceType.ELECTRICITY, -power_draw)


## Overriding implementations should call super() at the beginning
func _on_turn_ended(_turn_number:int) -> void:
	pass


func _on_Area2D_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Emitted: ", building_id)
			Signals.building_selected.emit(building_id)


func get_build_cost() -> Cost:
	return get_upgrade_cost(1)


## Level 1 = build cost, level 2 = level 2
func get_upgrade_cost(level: int) -> Cost:
	
	if level <= 0 or level > max_level:
		return null
	
	if level > building_spec.cost.size():
		printerr("You need to add a cost for level ", level, " on building ", self.name)
		return null
	
	return building_spec.cost[level - 1]


func get_type() -> BuildingManager.BuildingType:
	return building_spec.type
	

## draw outline around building in cursor mode
func _draw():
	if not is_cursor:
		return

	var dim := get_frame_wh()
	var rect = Rect2(-dim / 2, dim)
	draw_rect(rect, outline_color, false, outline_thickness)


func set_cursor_mode(enabled: bool) -> void:
	is_cursor = enabled
	queue_redraw()
	
	if is_cursor:
		z_index = order_man.order.CURSOR
	else:
		z_index = order_man.order.BUILDINGS


# adapted from: https://godotforums.org/d/19253-get-size-of-an-animated-sprite/9
## Get width x height of first frame of current animation
func get_frame_wh() -> Vector2:
	var anim_sprite := $AnimatedSprite2D
	var sprite_frames = anim_sprite.sprite_frames
	var texture = sprite_frames.get_frame_texture(anim_sprite.animation, 0)
	var texture_size = texture.get_size()
	var as2d_size = texture_size * anim_sprite.get_scale()
	return Vector2(as2d_size.x, as2d_size.y)
