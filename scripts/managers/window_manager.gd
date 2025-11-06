extends Node

# window_stack tracks the windows
# guaranteed to represent popup order
var window_stack: Array = []
# ui_root is what appears on the screen
# NOT guaranteed to always represent popup order
var ui_root: Node = null


func set_ui_root(node: Node):
	ui_root = node


func push(window: Node):
	# push to ui_root
	ui_root.add_child(window)
	# push to window_stack
	window_stack.append(window)
	print("UI STACK: ", window_stack.size())


func pop():
	if window_stack.size() > 0:
		var top = window_stack.pop_back()
		top.queue_free()
	print("UI STACK: ", window_stack.size())


func top() -> Node:
	if window_stack.size() > 0:
		return window_stack[-1]
	else:
		return null


func has_windows() -> bool:
	return window_stack.size() > 0
