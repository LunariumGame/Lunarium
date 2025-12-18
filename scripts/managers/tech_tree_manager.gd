class_name TechTreeManager
extends Node

const UPGRADES_FOLDER_PATH: String = "res://resources/tech_tree_upgrades"
const MAX_TIER: int = 10

# An array that stores all of the upgrades and stays constant after loading at ready
var all_tech_tree_nodes: Array[TechTreeNode]
# An array that stores upgrades by tier, whose order is randomizes, and changes as upgrades are grabbed
var tech_tree_nodes: Array

func _ready() -> void:
	
	# Create arrays for tech_tree_nodes
	# Add one so that tier maps directly to array indices
	for i in range(MAX_TIER + 1):
		var arr: Array[TechTreeNode] = []
		tech_tree_nodes.append(arr)
	
	# Parse all upgrade specs and create nodes
	var upgrade_specs: Array[Resource] = get_folder_contents(UPGRADES_FOLDER_PATH)
	for spec in upgrade_specs:
		var current: TechTreeNode = TechTreeNode.new()
		current.spec = spec
		# unlocked and bought are false by default
		all_tech_tree_nodes.append(current)
	
	reshuffle_upgrade_list()
	
	# DEBUG
	#for node in all_tech_tree_nodes:
		#print(node.spec.name)


func reshuffle_upgrade_list() -> void:
	# Shifted one for nice indexing
	for i in range(MAX_TIER + 1):
		reshuffle_upgrade_tier(i)


func reshuffle_upgrade_tier(tier: int) -> void:
	# Clean out upgrade list if it isn't already
	tech_tree_nodes[tier].clear()
	
	# Populate arrays with tiered upgrades
	for upgrade in all_tech_tree_nodes:
		var current_tier: int = upgrade.spec.tier
		if current_tier == tier:
			tech_tree_nodes[tier].append(upgrade)
	
	# Randomize the order of the upgrades
	tech_tree_nodes[tier].shuffle()


func get_random_upgrade() -> TechTreeNode:
	var rand_tier: int = randi_range(0, MAX_TIER)
	if tech_tree_nodes[rand_tier].is_empty():
		reshuffle_upgrade_tier(rand_tier)
	
	# Using pop instead of access means no duplicate upgrades until you've seen them all once
	return tech_tree_nodes[rand_tier].pop_back()


func get_random_upgrade_of_tier(tier: int) -> TechTreeNode:
	if tech_tree_nodes[tier].is_empty():
		reshuffle_upgrade_tier(tier)
	
	# Using pop instead of access means no duplicate upgrades until you've seen them all once
	return tech_tree_nodes[tier].pop_back()


#https://docs.godotengine.org/en/stable/classes/class_diraccess.html
# Loads all resource files from a directory into an array
func get_folder_contents(path: String) -> Array[Resource]:
	var upgrade_specs: Array[Resource]
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Skip directories
			if dir.current_is_dir():
				file_name = dir.get_next()
				continue
			
			var res = ResourceLoader.load(path + "/" + file_name)
			upgrade_specs.append(res)
			
			file_name = dir.get_next()
	else:
		print_debug("An error occurred when trying to access the files in" + path)
	
	return upgrade_specs
