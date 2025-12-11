extends Node

## Fires at the start of a turn.
signal turn_started(turn_number:int)
signal turn_started_power_plant(turn_number:int)
signal turn_process_power_draw(turn_number:int)
signal turn_started_eco_dome(turn_number:int)
signal turn_started_refinery(turn_number:int)
signal turn_started_residential(turn_number:int)

## Fires at the end of a turn.
signal turn_ended(turn_number:int)
signal turn_ended_power_plant(turn_number:int)
signal turn_ended_eco_dome(turn_number:int)
signal turn_ended_refinery(turn_number:int)
signal turn_ended_residential(turn_number:int)

# specific signals
signal recompute_power_plants()
signal toggle_tutorial()

# building signals
signal building_built(building: Node)
signal building_stats_changed()

## Emitted when the amount of a resource that the player has is changed.
signal resource_value_changed()
signal electricity_recomputed()

signal settings_opened()
signal settings_closed()

signal building_selected()

## Emitted when the opening movie is opened/closed
signal opening_movie_started_from_intro()
signal opening_movie_stopped_from_intro()

## Emitted when the game is won
signal game_won()

## Emitted when the game is lost
signal game_lost()

signal end_screen_closed()

## Emitted when a shuttle arrives
signal shuttle_arrived(pax:int)

## Emitted when a shuttle attempts to spawn,
## but fails due to insufficient housing
signal shuttle_blocked_by_population_cap()

## Emitted when colonists die
signal colonist_died(num_dead:int)

## Emitted for notification-worthy events
signal notification(n:NotificationManager.Notification)
