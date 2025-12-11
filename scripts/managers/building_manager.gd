class_name BuildingManager
extends Node

# Arbitrarily large because camera limits the world now
const WIDTH: int = 25000
const HEIGHT: int = 25000

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
	REACTOR,
	RESIDENCE,
}

var _pos_to_building_id: Dictionary[Vector2i, int] = {}
var building_id_to_node: Dictionary[int, Building] = {}
var _id_to_type = {}
var _buildings: Dictionary[Vector2i, int] = {}
var building_tiles = {} # Dictionary[int, Array[Vector2i]]
var adjacent_tiles = {} # Dictionary[int, Array[Vector2i]]
var _building_id_counter := 1


func _ready() -> void:
	# 0 = EMPTY
	_id_to_type[0] = BuildingType.EMPTY


func can_purchase(building_spec: BuildingSpec, level_index: int) -> bool:
	# Out of bounds cost level
	if level_index < 0 or level_index >= building_spec.cost_levels.size():
		return false

	var cost_spec := building_spec.cost_levels[level_index]
	var cost_dict: Dictionary = cost_spec.cost
	for resource_type in cost_dict.keys():
		var required: float = cost_dict[resource_type]
		var current: float = resource_manager.get_resource(resource_type)
		if current < required:
			return false

	return true


func can_build(building_spec: BuildingSpec, position: Vector2i, width: int, height: int) -> bool:
	# If no cost spec, don't place
	if building_spec.cost_levels.size() == 0:
		return false
	
	# Check cost
	if !can_purchase(building_spec, 0):
		return false

	# Bounds check
	if (position.x < -WIDTH or position.x + width > WIDTH or 
				position.y < -HEIGHT or position.y + height > HEIGHT):
		print_debug("build call out of bounds!")
		return false

	# Check for existing buildings
	for x in range(position.x, position.x + width):
		for y in range(position.y, position.y + height):
			if get_building(x, y) != BuildingType.EMPTY:
				print_debug("trying to place on existing building")
				return false
	
	return true

## returns building id if built successfully, 0 otherwise, based on cost and adjacency to other Building nodes
func build(building: Building, position: Vector2i, width: int, height: int) -> int:
	
	var building_spec := building.building_spec
	
	if not can_build(building_spec, position, width, height):
		return 0
	
	var cost_spec := building_spec.cost_levels[0]
	var cost_dict: Dictionary = cost_spec.cost
	
	# check if we have enough resources
	for resource_type in cost_dict.keys():
		var required: float = cost_dict[resource_type]
		var current := resource_manager.get_resource(resource_type)
		if current < required:
			return 0

	# Subtract cost safely
	for resource_type in cost_dict.keys():
		resource_manager.add_precalculated(resource_type, -cost_dict[resource_type])
	
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
	#get_adjacent_buildings(_building_id_counter)
	
	_building_id_counter += 1
	var _building_id: int = _building_id_counter - 1

	building_id_to_node[_building_id] = building
	return _building_id


func try_upgrade(building: Building) -> bool:
	var next_level := building.current_level + 1

	# Check bounds
	if next_level > building.max_level:
		return false

	var building_spec := building.building_spec
	var level_index := next_level - 1   # level 1 uses index 0, etc.

	# Ensure cost exists
	if level_index >= building_spec.cost_levels.size():
		return false

	# Can we buy it?
	if not can_purchase(building_spec, level_index):
		return false

	# Subtract the cost
	var cost_dict := building_spec.cost_levels[level_index].cost
	for resource_type in cost_dict.keys():
		resource_manager.add_precalculated(resource_type, -cost_dict[resource_type])

	# Apply the upgrade
	building.current_level = next_level

	return true


## DOES NOT ACTUALLY UPGRADE, JUST A REAL BOOL RETURN
func allowed_to_upgrade(building: Building) -> bool:
	var next_level := building.current_level + 1

	# Check bounds
	if next_level > building.max_level:
		return false

	var building_spec := building.building_spec
	var level_index := next_level - 1   # level 1 uses index 0, etc.

	# Ensure cost exists
	if level_index >= building_spec.cost_levels.size():
		return false

	# Can we buy it?
	if not can_purchase(building_spec, level_index):
		return false

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
	if (position.x < -WIDTH or position.x >= WIDTH or 
				position.y < -HEIGHT or position.y >= HEIGHT):
		#print_debug("requesting building from out of bounds!")
		return -1
	
	return get_building(position.x, position.y)


func get_building_type(position: Vector2i) -> BuildingType:
	
	# Bounds check
	if (position.x < -WIDTH or position.x >= WIDTH or 
				position.y < -HEIGHT or position.y >= HEIGHT):
		#print_debug("requesting building from out of bounds!")
		return BuildingType.EMPTY
	
	var id: int = get_building_id(position)
	return _id_to_type[id]


func get_building_type_from_id(id: int) -> BuildingType:
	if id == -1:
		return BuildingType.HEADQUARTERS
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
	return _pos_to_building_id.get(Vector2i(x, y), 0)


func _set_building(x:int, y:int, id:int) -> void:
	_pos_to_building_id.set(Vector2i(x, y), id)
