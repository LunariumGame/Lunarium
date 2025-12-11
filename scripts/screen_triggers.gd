## Handles screens that are opened by signals
extends Node

const VICTORY = preload("res://scenes/screens/victory.tscn")
const LOSS = preload("res://scenes/screens/loss.tscn")
const OPENINGMOVIE = preload("res://scenes/screens/opening_movie.tscn")
const CREDITS = preload("res://scenes/screens/credits.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.game_won.connect(_open_victory_screen)
	Signals.game_lost.connect(_open_loss_screen)
	Signals.opening_movie_started_from_intro.connect(_open_opening_movie_from_intro)
	Signals.victory_screen_closed.connect(_open_credits_from_victory)
	Signals.defeat_screen_closed.connect(_open_credits_from_defeat)


func _open_victory_screen() -> void:
	window_manager.push(VICTORY.instantiate())


func _open_loss_screen() -> void:
	window_manager.push(LOSS.instantiate())


func _open_opening_movie_from_intro() -> void:
	var opening_movie := OPENINGMOVIE.instantiate()
	# tell the instantiated opening movie where it is being played from
	opening_movie.caller = opening_movie.Callers.START
	
	window_manager.push(opening_movie)

func _open_credits_from_victory() -> void:
	var credits := CREDITS.instantiate()
	# tell the instantiated opening movie where it is being played from
	credits.caller = credits.Callers.VICTORY
	
	window_manager.push(credits)

func _open_credits_from_defeat() -> void:
	var credits := CREDITS.instantiate()
	# tell the instantiated opening movie where it is being played from
	credits.caller = credits.Callers.DEFEAT
	
	window_manager.push(credits)
