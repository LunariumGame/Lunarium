extends Label

@export var resource:ResourceManager.ResourceType:
	set(v):
		resource = v
		if is_node_ready():
			_update_display(resource_manager.get_resource(resource))
	get:
		return resource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.resource_value_changed.connect(_on_resource_value_changed)
	_update_display(resource_manager.get_resource(resource))


func _on_resource_value_changed(_resource:ResourceManager.ResourceType, value:float) -> void:
	if _resource == resource:
		_update_display(value)


func _update_display(value:float) -> void:
	text = "%d" % [value]
