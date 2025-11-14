# update building texture. used for cursor-click in GUI and when a building is upgraded
class_name UpdateBuildingTexture
extends Sprite2D

func _ready() -> void:
	Signals.on_building_click.connect(set_current_texture)
	
#	
func set_current_texture(current_building_texture: Texture2D) -> void:
	texture = current_building_texture
