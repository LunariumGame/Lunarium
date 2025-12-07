extends Node

## Fires at the start of a turn.
signal turn_started(turn_number:int)

## Fires at the end of a turn.
signal turn_ended(turn_number:int)

## Fires during the electricity generation phase of the inter-turn period
signal turn_electricity_generation(previous_turn_number:int)


## Emitted when the amount of a resource that the player has is changed.
signal resource_value_changed(resource:ResourceManager.ResourceType, value:float)

signal settings_opened()

signal building_selected()


## Emitted when the game is won
signal game_won()

## Emitted when the game is lost
signal game_lost()

## Emitted when a shuttle arrives
signal shuttle_arrived()
