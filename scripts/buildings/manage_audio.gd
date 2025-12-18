extends Node


## play stream of specified node. will not reset while a play() of this stream is active.
## If another stream of this specific Building instance is playing, it will replace it
func play_audio(playing_node: AudioStreamPlayer2D):
	var audio_nodes := get_children()
	for node in audio_nodes:
		if node.name != playing_node.name:
			if node.playing:
				node.stop()
	if not playing_node.playing:
		playing_node.play()
