class_name BuildingManager
extends Node

const WIDTH: int = 10
const HEIGHT: int = 10

enum BuildingType {
	# default value
	EMPTY = 0,
	HEADQUARTERS,
	ECO_DOME,
	IRON_REFINERY,
	MECH_QUARTER,
	POWER_PLANT,
	RESIDENCE
}

const DIRECTIONS = [
	Vector2i(1, 0), Vector2i(-1, 0),
	Vector2i(0, 1), Vector2i(0, -1),
	Vector2i(1, 1), Vector2i(-1, 1),
	Vector2i(1, -1), Vector2i(-1, -1),
]

var _building_id_counter := 1

# default values initialized to 0
var placed_buildings: Dictionary = {}
var id_to_type: Dictionary = {}


func register_building(
		   building_type: BuildingType, position: Vector2i, 
) -> int:
		
	var new_id: int = _building_id_counter
	
	placed_buildings[position] = new_id
	id_to_type[new_id] = building_type
	
	_building_id_counter += 1
	
	return new_id


# Returns a list of vector2i's surrounding a single tile
func get_adjacent_positions_single(position: Vector2i) -> Array[Vector2i]:
	var adjacent_positions: Array[Vector2i] = []
	
	for dir in DIRECTIONS:
		var adjacent = position + dir
		if adjacent.x >= 0 and adjacent.x < WIDTH and adjacent.y >= 0 and adjacent.y < HEIGHT:
			adjacent_positions.append(adjacent)
	
	return adjacent_positions


# Returns a list of building types surrounding a single tile
func get_adjacent_buildings_single(position: Vector2i) -> Array[BuildingType]:
	var surrounding: Array[Vector2i] = get_adjacent_positions_single(position)
	var adjacent_buildings: Array[BuildingType] = []
	
	for pos in surrounding:
		adjacent_buildings.append(get_building_type(pos))
	
	return adjacent_buildings


func get_adjacent_positions(position: Vector2i) -> Array[Vector2i]:
	# Get original type
	var my_building_id: int = get_building_id(position)
	
	if my_building_id == BuildingType.EMPTY:
		return []
	
	# Final list of adjacent positions
	var adjacent_positions: Array[Vector2i] = []
	# List of positions to check out
	var to_look_at: Array[Vector2i] = [position]
	
	var seen: Dictionary = {position: true}
	
	while not to_look_at.is_empty():
		var current: Vector2i = to_look_at.pop_front()
		var surrounding: Array[Vector2i] = get_adjacent_positions_single(current)
		
		for pos in surrounding:
			
			if seen.has(pos):
				continue
				
				
			if get_building_id(pos) == my_building_id:
				to_look_at.append(pos)
			else:
				adjacent_positions.append(pos)
			
			seen[pos] = true
	
	return adjacent_positions


func get_adjacent_buildings(position: Vector2i) -> Array[BuildingType]:
	var adjacent_positions: Array[Vector2i] = get_adjacent_positions(position)
	var adjacent_buildings: Array[BuildingType] = []
	
	for pos in adjacent_positions:
		adjacent_buildings.append(get_building_type(pos))
	
	return adjacent_buildings


func get_building_id(position: Vector2i) -> int:
	# World boundaries check
	if (position.x < 0 or position.x > WIDTH or 
				position.y < 0 or position.y > HEIGHT):
		print_debug("requesting building id from out of bounds!")
		return 0

	# return key. if it doesn't exist, return empty 0 value		
	return placed_buildings.get(position, BuildingType.EMPTY)


func get_building_type(position: Vector2i) -> BuildingType:
	var id: int = get_building_id(position)
	
	if id == BuildingType.EMPTY:
		return BuildingType.EMPTY;
	
	# if ID exists, return type. otherwise empty value
	return id_to_type.get(id, BuildingType.EMPTY)
