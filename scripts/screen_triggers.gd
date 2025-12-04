extends Node
## Handles screens that are opened by signals

const VICTORY = preload("uid://du8rqqwg06b8")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.game_won.connect(_open_victory_screen)


func _open_victory_screen() -> void:
	window_manager.push(VICTORY.instantiate())
