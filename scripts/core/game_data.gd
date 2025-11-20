# Acts as an API to access game data
# mostly used in GameManager
class_name GameData
extends Node

enum BuildingType {
	ECO_DOME,
	IRON_REFINERY,
	MECH_QUARTER,
	POWER_PLANT,
	RESIDENCE_BUILDING
}

var asset_db: AssetDatabase = preload("res://resources/asset_db.tres")


# upgrade level 1 by default (can be modified on a call in game manager)
func get_building_texture(type: BuildingType, level: int = 1) -> Texture2D:
	var building_name: String = BuildingType.find_key(type)
	
	if not asset_db.building_data.has(building_name):
		push_warning("no building data associated with: " + building_name)
		return null
	
	var data: BuildingData = asset_db.building_data[building_name]
	
	match level:
		1: return data.upgrade_1
		2: return data.upgrade_2
		3: return data.upgrade_3
		_:
				push_warning("invalid level requested: " + str(level))
				return data.level_1


# extend more methods here as we update asset_db...
