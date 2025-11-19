# template for building textures based on upgrade level
# Can also have other game data here, usable in GameData, such as cost (or can decouple and have elsewhere)
# just upgrades at the moment
class_name BuildingData
extends Resource

@export var building_scene : PackedScene

@export var upgrade_1: Texture2D
@export var upgrade_2: Texture2D
@export var upgrade_3: Texture2D
