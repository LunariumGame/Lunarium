class_name WorldScene
extends Node

@onready var tech_upgrade := get_node("TechTreeNode")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Test upgrade
	#if tech_upgrade is TechTreeNode:
		#tech_upgrade.unlocked = true
		#tech_upgrade.purchase()
	#else:
		#print_debug("wrong type")
	pass


func _on_end_turn_pressed() -> void:
	game_manager.end_turn()
