extends SubViewport

const BASE_WIDTH = 1920
const BASE_HEIGHT = 1080
const NATIVE_CURSOR_SIZE = Vector2i(32, 32)
const CURSOR_TARGET_OFFSET = Vector2(4, 4)

# safe hardware cursor size limit
const MAX_SIZE = Vector2i(128, 128)

@export var enable_shake_to_scale:bool = true
@export var enable_rainbow:bool = false

var shake_amount:float = 1.0
var hue:float = 0

@onready var texture_rect: TextureRect = $TextureRect


func _process(delta:float) -> void:
	var screen_size:Vector2i = DisplayServer.screen_get_size()
	var max_scale:float = minf(MAX_SIZE.x * 1.0 / NATIVE_CURSOR_SIZE.x , MAX_SIZE.y * 1.0 / NATIVE_CURSOR_SIZE.y)
	
	# rainbow cursor
	if enable_rainbow:
		hue = wrapf(hue + delta, 0, 1)
		
		var color := Color.RED
		color.ok_hsl_h = hue
		texture_rect.modulate = color
	else:
		texture_rect.modulate = Color.WHITE
	
	# calculate cursor shake scaling
	shake_amount += Input.get_last_mouse_velocity().length() * delta / screen_size.length()
	shake_amount = clampf(shake_amount - delta, 0, max_scale)
	var shake_scale:float = max(shake_amount, 1)
	if not enable_shake_to_scale:
		shake_scale = 1.0
	
	# calculate cursor scale
	var scale_factor:float = minf(1.0 * screen_size.x / BASE_WIDTH, 1.0 * screen_size.y / BASE_HEIGHT) * shake_scale
	scale_factor = maxf(1, minf(scale_factor, max_scale))
	
	# apply cursor scaling
	size = NATIVE_CURSOR_SIZE * scale_factor
	texture_rect.size = size
	
	# wait for render to complete
	await RenderingServer.frame_post_draw
	
	# update cursor
	Input.set_custom_mouse_cursor(self.get_texture(), Input.CURSOR_ARROW, CURSOR_TARGET_OFFSET * scale_factor)
