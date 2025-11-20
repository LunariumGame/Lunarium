class_name AssetDatabase
extends Resource 


# building textures can be populated in editor
# access texture given building key and desired upgrade level
@export var building_data: Dictionary[String, BuildingData]
