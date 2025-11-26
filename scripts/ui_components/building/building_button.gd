# On click of building button, populate BuildingCursor
class_name BuildingButton
extends Button

const BUILDING_CANVAS = (
	preload("res://scenes/ui_components/building_canvas.tscn")
)

var building_canvas: BuildingCanvas = null
var building_instance: BuildingCursor = null

@export var building_type: GameData.BuildingType


func _ready() -> void:
	add_to_group("building_buttons")
	pressed.connect(_populate_cursor_on_click)


# create a child of cursor that is a preview of the building clicked. follows cursor
func _populate_cursor_on_click() -> void:
	# if the BuildingCursor already exists, return
	var existing_cursor: BuildingCursor = (
		get_node_or_null(^"BuildingCursor")
	)
	
	if existing_cursor and is_instance_valid(existing_cursor):
		return
	
	# let other building buttons know this button has taken activity priority
	get_tree().call_group("tracker", "button_activated", self)
	
	var preview_texture: Texture2D = (
		game_data.get_building_texture(building_type)
	)
	
	if not preview_texture:
		return

	building_canvas = BUILDING_CANVAS.instantiate()	
	building_instance = building_canvas.get_node("BuildingCursor")
	
	building_instance.texture = preview_texture
	# assign BuildingCursor transparency to 50%
	building_instance.modulate.a = 0.5
	
	add_child(building_canvas)
	
	# set building type for world instantiation
	building_instance.initialize_building(building_type)
