class_name AnimationManager
extends AnimationTree

enum StateAction {
	PLACE,
	OFF,
	ON,
	CREATE,
	IDLE,
	BUFFED,
	DELETE
}

var state_machine: AnimationNodeStateMachinePlayback
var u_level: int
var parent_node: Building


func _ready() -> void:
	state_machine = get("parameters/playback") as AnimationNodeStateMachinePlayback
	parent_node = get_parent()
	active = true


func update_animation(action: StateAction) -> void:
	u_level = parent_node.current_level
	var target_node: String
	
	match action:
		StateAction.PLACE:
			target_node = "place_u1"
		StateAction.OFF:
			target_node = "off_u%d" % u_level
		StateAction.ON:
			target_node = "on_u%d" % u_level
		StateAction.CREATE:
			target_node = "create_u%d" % u_level
		StateAction.IDLE:
			target_node = "idle_u%d" % u_level
		StateAction.BUFFED:
			target_node = "buffed_u%d" % u_level
		StateAction.DELETE:
			target_node = "delete_u%d" % u_level
			
	state_machine.travel(target_node)
	
	await animation_finished
