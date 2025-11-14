# thinking commented logic should actually be specific to Building Button
class_name BuildingManager
extends Node

func _ready() -> void:
	pass
	#Signals.on_building_click.connect(populate_cursor_on_click)

	
# when user clicks building UI, populates cursor with building texture
#func populate_cursor_on_click(building_type: GameData.BuildingType) -> void:
#	game_data.get_building_texture(building_type)
