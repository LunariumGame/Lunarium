extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.turn_started.connect(_update_turn_number)
	_update_turn_number(game_manager.turn)


func _update_turn_number(turn:int) -> void:
	text = "TURN %d" % turn
