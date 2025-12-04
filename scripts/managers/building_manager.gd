class_name BuildingManager
extends Node

const WIDTH: int = 1000
const HEIGHT: int = 1000

const DIRECTIONS = [
	Vector2i(1, 0), Vector2i(-1, 0),
	Vector2i(0, 1), Vector2i(0, -1),
	Vector2i(1, 1), Vector2i(-1, 1),
	Vector2i(1, -1), Vector2i(-1, -1),
]

enum BuildingType {
	# result to empty is 0
	EMPTY,
	HEADQUARTERS,
	ECO_DOME,
	IRON_REFINERY,
	MECH_QUARTER,
	POWER_PLANT,
	RESIDENCE,
}

var _buildings: Array = []
var _id_to_type = {}
var _building_id_counter := 1


func _ready() -> void:
	# Populate buildings array with empty type
	for y in range(HEIGHT):
		var row: Array[BuildingType] = []
		for x in range(WIDTH):
			row.append(BuildingType.EMPTY)
		_buildings.append(row)
	
	# 0 = EMPTY
	_id_to_type[0] = BuildingType.EMPTY


func build(building_spec: BuildingSpec, position: Vector2i, width: int, height: int) -> void:
	# Check spec
	if building_spec.cost.size() == 0:
		return
	
	# Check cost
	var cost := building_spec.cost[0]
	for resource_type in cost.keys():
		var resource_cost:float = cost[resource_type]
		var current_amount: float = resource_manager.get_resource(resource_type)
		if current_amount < resource_cost:
			return
	
	# Subtract cost
	for resource_type in cost.keys():
		var resource_cost:float = cost[resource_type]
		resource_manager.add_precalculated(resource_type, -resource_cost)
	
	# Bounds check
	if (position.x < 0 or position.x + width > WIDTH or 
				position.y < 0 or position.y + height > HEIGHT):
		print_debug("build call out of bounds!")
		return
	
	# Check for existing buildings
	for x in range(position.x, position.x + width):
		for y in range(position.y, position.y + height):
			if _buildings[y][x] != BuildingType.EMPTY:
				print_debug("trying to place on existing building")
				return
	
	# Fill buildings array
	for x in range(position.x, position.x + width):
		for y in range(position.y, position.y + height):
			_buildings[y][x] = _building_id_counter
	
	# Create mapping
	_id_to_type[_building_id_counter] = building_spec.type
	
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


# Returns the building_id at a position or -1 if out of bounds
func get_building_id(position: Vector2i) -> int:
	# Bounds check
	if (position.x < 0 or position.x >= WIDTH or 
				position.y < 0 or position.y >= HEIGHT):
		print_debug("requesting building from out of bounds!")
		return -1
		
	return _buildings[position.y][position.x]


func get_building_type(position: Vector2i) -> BuildingType:
	var id: int = get_building_id(position)
	return _id_to_type[id]


# Returns the total number of buildings built if the type is not specified
# Returns the total number of buildings of a specified type otherwise
func get_num_buildings(type: BuildingType = BuildingType.EMPTY) -> int:
	
	if type == BuildingType.EMPTY:
		return _building_id_counter - 1
	
	var count: int = 0
	for id in _id_to_type.keys():
		if _id_to_type[id] == type:
			count += 1
	
	return count
