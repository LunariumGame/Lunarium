@tool
extends Node

signal scale_changed(new_scale:float)

var scale:float = 1:
	set(v):
		scale = v
		scale_changed.emit(v)
	get:
		return scale
