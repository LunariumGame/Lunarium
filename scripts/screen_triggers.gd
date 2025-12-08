extends Node
## Handles screens that are opened by signals

const VICTORY = preload("uid://du8rqqwg06b8")
const LOSS = preload("uid://du46r5f2n8vya")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.game_won.connect(_open_victory_screen)
	Signals.game_lost.connect(_open_loss_screen)


func _open_victory_screen() -> void:
	window_manager.push(VICTORY.instantiate())


func _open_loss_screen() -> void:
	window_manager.push(LOSS.instantiate())
