extends SubViewport

const BASE_WIDTH = 1920
const BASE_HEIGHT = 1080
const NATIVE_CURSOR_SIZE = Vector2i(32, 32)
const CURSOR_TARGET_OFFSET = Vector2(4, 4)
const MAX_SIZE = Vector2i(128, 128)

@onready var texture_rect: TextureRect = $TextureRect


func _process(delta:float) -> void:
	var size:Vector2i = DisplayServer.screen_get_size()
	var scale_factor:int = mini(size.x / BASE_WIDTH, size.y / BASE_HEIGHT)
	var max_scale:int = mini(MAX_SIZE.x / NATIVE_CURSOR_SIZE.x , MAX_SIZE.y / NATIVE_CURSOR_SIZE.y)
	scale_factor = maxi(1, mini(scale_factor, max_scale))
	
	size = NATIVE_CURSOR_SIZE * scale_factor
	texture_rect.size = size
	await RenderingServer.frame_post_draw
	Input.set_custom_mouse_cursor(self.get_texture(), Input.CURSOR_ARROW, CURSOR_TARGET_OFFSET * scale_factor)
