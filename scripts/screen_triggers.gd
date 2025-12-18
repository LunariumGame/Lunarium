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


func _open_victory_screen() -> void:
	var victory_tscn := VICTORY.instantiate()
	var victory_tscn_music: AudioStreamPlayer = victory_tscn.get_node("AudioStreamPlayer")
	window_manager.push(victory_tscn)
	# open credits after victory ditty finishes
	await get_tree().create_timer(victory_tscn_music.stream.get_length()).timeout
	window_manager.push(CREDITS.instantiate())


func _open_loss_screen() -> void:
	var loss_tscn := LOSS.instantiate()
	var loss_tscn_music: AudioStreamPlayer = loss_tscn.get_node("AudioStreamPlayer")
	window_manager.push(LOSS.instantiate())
	# open credits after loss ditty finishes
	await get_tree().create_timer(loss_tscn_music.stream.get_length()).timeout
	window_manager.push(CREDITS.instantiate())


func _open_opening_movie_from_intro() -> void:
	var opening_movie := OPENINGMOVIE.instantiate()
	# tell the instantiated opening movie where it is being played from
	opening_movie.caller = opening_movie.Callers.START
	
	window_manager.push(opening_movie)
