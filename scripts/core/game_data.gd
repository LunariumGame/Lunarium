# Acts as an API to access game data
# mostly used in GameManager
class_name GameData
extends Node

var asset_db: AssetDatabase = preload("res://resources/asset_db.tres")


# upgrade level 1 by default (can be modified on a call in game manager)
func get_building_texture(key: String, level: int = 1) -> Texture2D:
	if not asset_db.building_textures.has(key):
		push_warning("no building data associated with: " + name)
		return null
	
	var data: BuildingData = asset_db.building_data[name]
	
	match level:
		1: return data.level_1
		2: return data.level_2
		3: return data.level_3
		_:
				push_warning("invalid level requested: " + str(level))
				return data.level_1


# extend more methods here as we update asset_db...
