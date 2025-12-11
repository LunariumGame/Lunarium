extends Node

# window_stack tracks the windows
# guaranteed to represent popup order
var window_stack: Array[Node] = []
# ui_root is what appears on the screen
# NOT guaranteed to always represent popup order
var ui_root: Node = null
# main_menu is isolated so that it doesn't close
# upon usual ESC press 
var main_menu_holder: Node = null


func _ready() -> void:
	Signals.settings_opened.connect(open_settings_screen)
	Signals.controls_opened.connect(open_controls)

func set_ui_root(node: Node):
	ui_root = node


func set_main_menu_holder(node: Node):
	main_menu_holder = node


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		ui_cancel_pressed()
		get_viewport().set_input_as_handled()


func ui_cancel_pressed():
	if has_windows():
		# note that this happens only when the close signal has not been handled
		# fallback close() call
		# all windows must provide close method
		top().close()
	else:
		# should not open settings upon ESC press in main menu
		if not is_in_main_menu():
			open_settings_screen()


func open_main_menu_screen():
	var main_menu_scene = preload("res://scenes/screens/main_menu.tscn").instantiate()
	main_menu_holder.add_child(main_menu_scene)


func open_settings_screen():
	var settings_scene = preload("res://scenes/screens/settings.tscn").instantiate()
	push(settings_scene)


func push(window: Node):
	# push to ui_root
	ui_root.add_child(window)
	# push to window_stack
	window_stack.append(window)
	#print("UI STACK: ", window_stack.size())


func pop():
	if window_stack.size() > 0:
		var top_window:Node = window_stack.pop_back()
		top_window.queue_free()
	#print("UI STACK: ", window_stack.size())


func top() -> Node:
	return window_stack.back()


func has_windows() -> bool:
	return window_stack.size() > 0


func is_in_main_menu() -> bool:
	return main_menu_holder.get_child_count() > 0
	

func open_controls() -> void:
	var controls_scene = preload("res://scenes/screens/controls.tscn").instantiate()
	push(controls_scene)
