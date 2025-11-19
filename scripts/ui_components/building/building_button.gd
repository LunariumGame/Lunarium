# On click of building button, populate BuildingCursor
class_name BuildingButton
extends Button

const BUILDING_CURSOR = preload("res://scenes/ui_components/BuildingCursor.tscn")

var building_instance: BuildingCursor = null

# BuildingType enum
@export var building_type: GameData.BuildingType


func _ready() -> void:
	add_to_group("building_buttons")
	pressed.connect(_populate_cursor_on_click)
	pressed.connect(_activate_cleanup)


# let other building buttons know this button is active
func _activate_cleanup():
	get_tree().call_group("tracker", "button_activated", self)


# create a child of cursor that is a preview of the building clicked. follows cursor
func _populate_cursor_on_click() -> void:
	var preview_texture: Texture2D = game_data.get_building_texture(building_type)
	
	if not preview_texture:
		return
	
	building_instance = BUILDING_CURSOR.instantiate()
	building_instance.texture = preview_texture

	add_child(building_instance)
	
	# set building type for world instantiation
	building_instance.initialize_building(building_type)  
