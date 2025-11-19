# Currently, set up to populate l1 residence building. 
# create more build buttons for different buildings
# this logic will be ported below BuildingManager button
# 1) BuildingManager toggles GUI with 5 buttons for constructing buildings
# 2) those 5 constructed buildings are what this script attaches to
class_name BuildingButton
extends Button

const BUILDING_CURSOR = preload("res://scenes/ui_components/BuildingCursor.tscn")

var building_instance = null

# BuildingType enum
@export var building_type: GameData.BuildingType


func _ready() -> void:
	pressed.connect(populate_cursor_on_click)


# create a child of cursor that is a preview of the building clicked. follows cursor
func populate_cursor_on_click() -> void:
	var preview_texture: Texture2D = game_data.get_building_texture(building_type)
	
	if not preview_texture:
		return
	
	building_instance = BUILDING_CURSOR.instantiate()
	building_instance.texture = preview_texture

	get_tree().current_scene.add_child(building_instance)
	
	# set building type for world instantiation
	building_instance.initialize_building(building_type)  
	   
	
