extends Node

## Fires at the start of a turn.
signal turn_started(turn_number:int)

## Fires at the end of a turn.
signal turn_ended(turn_number:int)
