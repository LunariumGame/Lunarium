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
	Signals.turn_process_power_draw.connect(_process_power_draw)
	
	clickable_area.input_event.connect(_on_Area2D_input_event)
	scale = building_scale
	z_index = order_man.order.BUILDINGS
	queue_redraw()


func get_power_draw() -> float:
	return 0


func _process_power_draw(_turn_number:int) -> void:
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


func _on_turn_started(_turn_number:int) -> void:
	pass


func _on_Area2D_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Signals.building_selected.emit(building_id, _get_selection_payload())


# override it whenever possible in derived building classes
func _get_selection_payload() -> Dictionary:
	return {}


func upgrade_level() -> bool:
	var can_upgrade := build_man.try_upgrade(self)

	if can_upgrade:
		Signals.building_stats_changed.emit(self)
	
	return can_upgrade


func destroy() -> bool:
	return false


func get_type() -> BuildingManager.BuildingType:
	return building_spec.type
	

## draw outline around building in cursor mode
func _draw():
	if not is_cursor:
		return

	var dim: Vector2 = $Sprite2D.get_frame_wh()
	var rect = Rect2(-dim / 2, dim)
	draw_rect(rect, outline_color, false, outline_thickness)


func set_cursor_mode(enabled: bool) -> void:
	is_cursor = enabled
	queue_redraw()
	
	if is_cursor:
		z_index = order_man.order.CURSOR
	else:
		z_index = order_man.order.BUILDINGS


func emit_built_signal() -> void:
	pass
