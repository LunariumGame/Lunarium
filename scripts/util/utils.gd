extends Node

## given building_id, fetch a live PlacedBuilding node.
## returns null if does not exist.
func fetch_building(building_id: int) -> Building:
	var placed_buildings: Node = get_tree().get_root().get_node(
		"World/PlacedBuildings/"
	)
	
	var buildings = placed_buildings.get_children()
	var building_node: Building
	for building in buildings:
		var curr_name: String = building.name
		if curr_name.contains(str(building_id)):
			building_node = placed_buildings.get_node(curr_name)
			break
	return building_node
