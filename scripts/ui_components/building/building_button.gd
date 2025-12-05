# On click of building button, populate BuildingCursor
class_name BuildingButton
extends Button

const BUILDING_CANVAS = (
	preload("res://scenes/ui_components/building_canvas.tscn")
)

var building_canvas: BuildingCanvas = null
var cursor_instance: BuildingCursor = null

@export var building_scene: PackedScene


func _ready() -> void:
	add_to_group("building_buttons")
	pressed.connect(_populate_cursor_on_click)


# create a child of cursor that is a preview of the building clicked. follows cursor
func _populate_cursor_on_click() -> void:
	# if the BuildingCanvas already exists, return
	var existing_cursor: BuildingCanvas = (
		get_node_or_null(^"BuildingCanvas")
	)
	if existing_cursor and is_instance_valid(existing_cursor):
		return
		
	# return if scene was not assigned
	if building_scene == null:
		push_error("Assign a PackedScene to this BuildingButton")
		return
	
	# let other building buttons know this button has taken activity priority
	get_tree().call_group("tracker", "button_activated", self)
	
	building_canvas = BUILDING_CANVAS.instantiate()	
	cursor_instance = building_canvas.get_node("BuildingCursor")
	
	# expose building scene to cursor, and set texture as "off" frame
	cursor_instance.building_instance = building_scene.instantiate()
	cursor_instance.set_cursor_texture()
	
	add_child(building_canvas)
	
	print("Adding ", building_scene," child with button: ", name)	
