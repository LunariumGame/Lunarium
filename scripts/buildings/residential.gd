class_name Residential
extends Building

# Housing capacity per level
const CAPACITY_TABLE := [
	0, # lvl 0 unused
	20,
	40,
	80,
]

# Power usage per level
const POWER_TABLE := [
	0, # lvl 0 unused
	10,
	15,
	20,
]


func _ready() -> void:
	super()


func get_power_draw() -> float:
	if current_level < POWER_TABLE.size():
		return POWER_TABLE[current_level]
	return POWER_TABLE[-1]


func get_housing_capacity() -> int:
	if current_level < CAPACITY_TABLE.size():
		return CAPACITY_TABLE[current_level]
	return CAPACITY_TABLE[-1]
