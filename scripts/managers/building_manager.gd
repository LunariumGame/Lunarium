class_name BuildingManager
extends Node

const WIDTH: int = 5000
const HEIGHT: int = 5000

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

var _buildings: Dictionary[Vector2i, int] = {}
var _id_to_type := {}
var building_tiles = {} # Dictionary[int, Array[Vector2i]]
var adjacent_tiles = {} # Dictionary[int, Array[Vector2i]]
var _building_id_counter := 1


func _ready() -> void:
	
	# 0 = EMPTY
	_id_to_type[0] = BuildingType.EMPTY


func can_build(building_spec: BuildingSpec, position: Vector2i, width: int, height: int) -> bool:
	# If no cost spec, don't place
	if building_spec.cost_levels.size() == 0:
		return false
	
	# Check cost
	var cost_spec := building_spec.cost_levels[0]
	var cost_dict: Dictionary = cost_spec.cost
	for resource_type in cost_dict.keys():
		var resource_cost:float = cost_dict[resource_type]
		var current_amount: float = resource_manager.get_resource(resource_type)
		if current_amount < resource_cost:
			return false
	
	# Bounds check
	if (position.x < 0 or position.x + width > WIDTH or 
				position.y < 0 or position.y + height > HEIGHT):
		#print_debug("build call out of bounds!")
		return false
	
	# Check for existing buildings
	for x in range(position.x, position.x + width):
		for y in range(position.y, position.y + height):
			if get_building(x, y) != BuildingType.EMPTY:
				#print_debug("trying to place on existing building")
				return false
	
	return true


## returns true if built successfully, false otherwise, based on cost and adjacency to other Building nodes
func build(building_spec: BuildingSpec, position: Vector2i, width: int, height: int) -> bool:
	
	if not can_build(building_spec, position, width, height):
		return false
	
	var cost_spec := building_spec.cost_levels[0]
	var cost_dict: Dictionary = cost_spec.cost
	
	# Subtract cost
	for resource_type in cost_dict.keys():
		var resource_cost:float = cost_dict[resource_type]
		resource_manager.add_precalculated(resource_type, -resource_cost)
	
	# Fill buildings array
	var tiles = []
	for x in range(position.x, position.x + width):
		for y in range(position.y, position.y + height):
			_set_building(x, y, _building_id_counter)
			tiles.append(Vector2i(x, y))
	
	# Precompute adjacent tiles at build time
	var adjacency_dict = {}
	for tile in tiles:
		for neighbor in get_adjacent_positions_single(tile):
			if _buildings.get(neighbor, 0) != _building_id_counter:
				adjacency_dict[neighbor] = true
	adjacent_tiles[_building_id_counter] = adjacency_dict.keys()
	
	# Create mappings
	_id_to_type[_building_id_counter] = building_spec.type
	building_tiles[_building_id_counter] = tiles
	
	# DEDBUGGG
	get_adjacent_buildings(_building_id_counter)
	
	_building_id_counter += 1
	return true


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


func get_adjacent_positions(building_id: int) -> Array:
	
	return adjacent_tiles.get(building_id, [])


func get_adjacent_buildings(building_id: int) -> Array[BuildingType]:
	var adjacent_positions: Array = get_adjacent_positions(building_id)
	var adjacent_buildings: Array[BuildingType] = []
	
	for pos in adjacent_positions:
		adjacent_buildings.append(get_building_type(pos))
	
	return adjacent_buildings


## Returns the building_id at a position or -1 if out of bounds
func get_building_id(position: Vector2i) -> int:
	# Bounds check
	if (position.x < 0 or position.x >= WIDTH or 
				position.y < 0 or position.y >= HEIGHT):
		#print_debug("requesting building from out of bounds!")
		return -1
	
	return get_building(position.x, position.y)


func get_building_type(position: Vector2i) -> BuildingType:
	
	# Bounds check
	if (position.x < 0 or position.x >= WIDTH or 
				position.y < 0 or position.y >= HEIGHT):
		#print_debug("requesting building from out of bounds!")
		return BuildingType.EMPTY
	
	var id: int = get_building_id(position)
	return _id_to_type[id]


## Returns the total number of buildings built if the type is not specified
## Otherwise, returns the total number of buildings of a specified type otherwise
func get_num_buildings(type: BuildingType = BuildingType.EMPTY) -> int:
	
	if type == BuildingType.EMPTY:
		return _building_id_counter - 1
	
	var count: int = 0
	for id in _id_to_type.keys():
		if _id_to_type[id] == type:
			count += 1
	
	return count


func get_building(x:int, y:int) -> int:
	return _buildings.get(Vector2i(x, y), 0)


func _set_building(x:int, y:int, id:int) -> void:
	_buildings.set(Vector2i(x, y), id)
