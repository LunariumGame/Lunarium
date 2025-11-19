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
# assign a building's PackedScene to the appropriate Texture2D
func get_building_scene(type: BuildingType, upgrade: int = 1) -> Building:
	var building_name: String = BuildingType.find_key(type)
	
	if not asset_db.building_data.has(building_name):
		assert(false, "no building data associated with: " + building_name)
		return null
	
	var data: BuildingData = asset_db.building_data[building_name]
	
	var building_node: Building = data.building_scene.instantiate()
	
	match upgrade:
		1: building_node.set_building_texture(data.upgrade_1)
		2: building_node.set_building_texture(data.upgrade_2)
		3: building_node.set_building_texture(data.upgrade_3)
		_:
				assert(false, "invalid level requested: " + str(upgrade))
				return null
				
	return building_node


# extend more methods here as we update asset_db...
