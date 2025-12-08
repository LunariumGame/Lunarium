## Handles screens that are opened by signals
extends Node

const VICTORY = preload("res://scenes/screens/victory.tscn")
const LOSS = preload("res://scenes/screens/loss.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.game_won.connect(_open_victory_screen)
	Signals.game_lost.connect(_open_loss_screen)


func _open_victory_screen() -> void:
	window_manager.push(VICTORY.instantiate())


func _open_loss_screen() -> void:
	window_manager.push(LOSS.instantiate())
