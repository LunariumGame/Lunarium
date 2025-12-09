	# not abstract: otherwise children cannot invoke parent methods, or use super()
class_name Building
extends Node2D


@export var building_spec: BuildingSpec
@export var max_level: int
# NOTE: scale all inherited building sprites here across the entire game
@export var building_scale := Vector2(4, 4)

@export var outline_color: Color = Color(0.0, 0.0, 0.0, 0.5)
@export var outline_thickness: float = 1.5

@onready var clickable_area: Area2D = $Area2D
@onready var destroy_audio: AudioStreamPlayer2D = $Audio/Destroy
@onready var anim_manager: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var alpha_speed: float = 4.0
@export var min_alpha: float = 0.25
@export var max_alpha: float = 0.75

var is_cursor: bool = false

var building_id: int = -1
var is_powered: bool
var current_level: int = 1


func _ready() -> void:
	Signals.turn_process_power_draw.connect(_process_power_draw)
	
	clickable_area.input_event.connect(_on_Area2D_input_event)
	
	scale = building_scale
	
	z_index = order_man.order.BUILDINGS
	#sprite_2d.material = sprite_2d.material.duplicate() # NOTE: For building pixel outline highlights, makes material unique for highlighting
	queue_redraw()
	

var _time: float = 0.0
func _process(delta: float) -> void:
	if is_cursor:
		_time += delta * alpha_speed
		# Calculate alpha value with sine wave
		var alpha = min_alpha + (max_alpha - min_alpha) * (sin(_time) * 0.5 + 0.5)
		modulate.a = alpha


func get_power_draw() -> float:
	return 0


func _process_power_draw(_turn_number:int) -> void:
	var power_draw:float = self.get_power_draw()
	var available_electricity:float = resource_manager.get_resource(
			ResourceManager.ResourceType.ELECTRICITY)
	
	var state_machine_playback = $AnimationTree.get("parameters/playback")
	var current_animation_state = state_machine_playback.get_current_node()
	is_powered = power_draw <= available_electricity
	if is_powered:
		if current_animation_state == "off_u1" or current_animation_state == "off_u2" or current_animation_state == "off_u3":
			anim_manager.update_animation(anim_manager.StateAction.IDLE)
		resource_manager.add_precalculated(
				ResourceManager.ResourceType.ELECTRICITY, -power_draw)
	else:
		if current_animation_state != "off_u1" or current_animation_state != "off_u2" or current_animation_state != "off_u3":
			anim_manager.update_animation(anim_manager.StateAction.OFF)


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
		# special condition, because _get_selection_payload gets called in upgrade
		if not $Audio/Create.playing:
			$Audio.play_audio($Audio/Select)
		return {}


func upgrade_level() -> bool:
	var can_upgrade := build_man.try_upgrade(self)

	if can_upgrade:
		Signals.building_stats_changed.emit(self)
		$Audio.play_audio($Audio/Create)
		anim_manager.update_animation(AnimationManager.StateAction.CREATE)
	
	return can_upgrade


func destroy() -> void:
	$Audio.play_audio($Audio/Destroy)
	$AnimationTree.update_animation($AnimationTree.StateAction.DELETE)
	await $AnimationTree.animation_finished
	# suppress "wonky default frame" AnimationTree throws up at end
	$Sprite2D.visible = false
	await $Audio/Destroy.finished
	queue_free()


func get_type() -> BuildingManager.BuildingType:
	return building_spec.type
	

## draw outline around building in cursor mode
## disappears if not refreshed with queue_redraw()
func _draw():
	if not is_cursor:
		return
	
	var dim: Vector2 = $Sprite2D.get_frame_wh()
	dim += Vector2(3, 3)
	var rect = Rect2(-dim / 2 , dim)
	
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
