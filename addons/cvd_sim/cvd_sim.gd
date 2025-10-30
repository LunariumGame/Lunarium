@tool
extends EditorPlugin

const CVD_DOCK = preload("uid://doad7ti32kfs")
const CVD_SIMULATOR = preload("uid://y7hyrhysarul")

var _cvd_simulator:CvdSimulator
var _dock:CvdDock

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	_cvd_simulator = CVD_SIMULATOR.instantiate()
	_cvd_simulator.filter = CvdSimulator.Filter.NONE
	get_tree().root.add_child(_cvd_simulator)
	
	_dock = CVD_DOCK.instantiate()
	_dock.cvd_filter_selected.connect(_set_filter)
	add_control_to_dock(DOCK_SLOT_LEFT_UR, _dock)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	_cvd_simulator.queue_free()
	_cvd_simulator = null
	
	_dock.queue_free()
	remove_control_from_docks(_dock)
	_dock = null


func _set_filter(filter:CvdSimulator.Filter) -> void:
	_cvd_simulator.filter = filter
