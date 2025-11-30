class_name BuildingManager
extends Node

const WIDTH: int = 10
const HEIGHT: int = 10

enum BuildingType {
	EMPTY,
	HEADQUARTERS,
	ECO_DOME,
	IRON_REFINERY,
	MECH_QUARTER,
	POWER_PLANT,
	RESIDENCE
}

const DIRECTIONS = [
	Vector2i(1, 0), 
	Vector2i(-1, 0),
	Vector2i(0, 1), 
	Vector2i(0, -1),
	Vector2i(1, 1), 
	Vector2i(-1, 1),
	Vector2i(1, -1), 
	Vector2i(-1, -1),
]

var _building_id_counter := 0

var buildings: Array = []
var id_to_type = {}


func _ready() -> void:
	# Populate buildings array with empty type
	for y in range(HEIGHT):
		var row: Array[BuildingType] = []
		for x in range(WIDTH):
			row.append(BuildingType.EMPTY)
		buildings.append(row)


func build(building_type: BuildingType, position: Vector2i, width: int, height: int) -> void:
	
	# Bounds check
	if (position.x < 0 or position.x + width > WIDTH or 
				position.y < 0 or position.y + height > HEIGHT):
		print_debug("build call out of bounds!")
		return
	
	# Fill buildings array
	for x in range(position.x, position.x + width):
		for y in range(position.y, position.y + height):
			buildings[y][x] = _building_id_counter
	
	# Create mapping
	id_to_type[_building_id_counter] = building_type
	
	_building_id_counter += 1

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
	
	# Create seen board
	var seen: Array = []
	for y in range(HEIGHT):
		var row: Array[bool] = []
		for x in range(WIDTH):
			row.append(false)
		seen.append(row)
	
	# Final list of adjacent positions
	var adjacent_positions: Array[Vector2i] = []
	
	# List of positions to check out
	var to_look_at: Array[Vector2i] = []
	to_look_at.append(position)
	
	while not to_look_at.is_empty():
		var current: Vector2i = to_look_at.pop_front()
		var surrounding: Array[Vector2i] = get_adjacent_positions_single(current)
		
		for pos in surrounding:
			
			if seen[pos.y][pos.x]:
				continue
				
			if get_building_id(pos) == my_building_id:
				to_look_at.append(pos)
			else:
				adjacent_positions.append(pos)
			
			seen[pos.y][pos.x] = true
	
	return adjacent_positions


func get_adjacent_buildings(position: Vector2i) -> Array[BuildingType]:
	var adjacent_positions: Array[Vector2i] = get_adjacent_positions(position)
	var adjacent_buildings: Array[BuildingType] = []
	
	for pos in adjacent_positions:
		adjacent_buildings.append(get_building_type(pos))
	
	return adjacent_buildings


func get_building_id(position: Vector2i) -> int:
	# Bounds check
	if (position.x < 0 or position.x > WIDTH or 
				position.y < 0 or position.y > HEIGHT):
		print_debug("requesting building id from out of bounds!")
		return -1
		
	return buildings[position.y][position.x]


func get_building_type(position: Vector2i) -> BuildingType:
	# Bounds check
	if (position.x < 0 or position.x > WIDTH or 
				position.y < 0 or position.y > HEIGHT):
		print_debug("requesting building type from out of bounds!")
		return BuildingType.EMPTY
		
	var id: int = get_building_id(position)
	return id_to_type[id]
