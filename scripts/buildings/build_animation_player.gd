## Build the AnimationPlayer using a specified AnimationLibrary
extends AnimationPlayer

@export var animation_data: Dictionary = {
	# animation frame data for a specific building
}

@export var sprite_node_path: NodePath = NodePath("../Sprite2D")
# rebuild animations on every run
@export var rebuild_on_ready: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rebuild_on_ready and not animation_data.is_empty():
		build_animations()


func build_animations():
	# get animation library (no default, populate if it doesn't exist)
	var lib: AnimationLibrary
	if has_animation_library(""):
		lib = get_animation_library("")
	else:
		print("No AnimationLibrary found")
		return

	# populate library from export var		
	for anim_name in animation_data:
		var data = animation_data[anim_name]
		
		# required values
		var frames: Array = data["frames"]
		var fps: float = data["fps"]
		var loop_mode: Animation.LoopMode = data["loop_mode"]
		
		var animation: Animation
		if lib.has_animation(anim_name):
			animation = lib.get_animation(anim_name)
			# Clear all existing tracks
			for i in range(animation.get_track_count() - 1, -1, -1):
				animation.remove_track(i)
		else:
			animation = Animation.new()
			lib.add_animation(anim_name, animation)
			
		# calculate duration
		var duration := float(frames.size()) / fps
		animation.length = duration
		animation.loop_mode = loop_mode
		
		# create frame track
		var track_idx = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(track_idx, 
				sprite_node_path.get_concatenated_names() + ":frame"
		)
		animation.track_set_interpolation_type(track_idx,Animation.INTERPOLATION_NEAREST)
		
		for i in range(frames.size()):
			var time: float = float(i) / fps
			var frame_number: int = frames[i]
			animation.track_insert_key(track_idx, time, frame_number)
			
		print("Built animation '%s': %d frames at %d fps (%.2fs duration, loop_mode=%d)" % 
			[anim_name, frames.size(), fps, duration, loop_mode])
			
	
# trigger animation rebuild if needed
# Helper function to manually trigger animation rebuild
func rebuild():
	if not animation_data.is_empty():
		build_animations()
	else:
		push_warning("No animation_data defined, cannot rebuild animations")
