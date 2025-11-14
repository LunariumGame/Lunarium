extends Node

## Fires at the start of a turn.
signal turn_started(turn_number:int)

## Fires at the end of a turn.
signal turn_ended(turn_number:int)


## Emitted when the amount of a resource that the player has is changed.
signal resource_value_changed(resource:ResourceManager.ResourceType, value:float)

signal settings_opened()

# emitted when a building is clicked
signal on_building_click(new_building_texture: Texture2D)
