@tool
class_name CvdSimulator
extends CanvasLayer

enum Filter {
	NONE,
	PROTANOMALY,
	DEUTERANOMALY,
	TRITANOMALY,
	MONOCHROME,
}

## Color transformation matrices
const COLOR_MATRICES:Dictionary[Filter, Basis] = {
	Filter.NONE: Basis.IDENTITY,
	
	# Transformation matrices for Protanomaly, Deuteranomaly, and Tritanomaly are
	# from the following paper:
	# Gustavo M. Machado, Manuel M. Oliveira, and Leandro A. F. Fernandes "A Physiologically-based
	# Model for Simulation of Color Vision Deficiency". IEEE Transactions on Visualization
	# and Computer Graphics. Volume 15 (2009), Number 6, November/December 2009. pp. 1291-1298.
	# https://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html
	Filter.PROTANOMALY: Basis(
		Vector3(0.152286, 0.114503, -0.003882),
		Vector3(1.052583, 0.786281, -0.048116),
		Vector3(-0.204868, 0.099216, 1.051998),
	),
	
	Filter.DEUTERANOMALY: Basis(
		Vector3(0.367322, 0.280085, -0.011820),
		Vector3(0.860646, 0.672501, 0.042940),
		Vector3(-0.227968, 0.047413, 0.968881),
	),
	
	Filter.TRITANOMALY: Basis(
		Vector3(1.255528, -0.078411, 0.004733),
		Vector3(-0.076749, 0.930809, 0.691367),
		Vector3(-0.178779, 0.147602, 0.303900),
	),
	
	# Based on the luminance equation https://docs.gimp.org/2.10/en/gimp-filter-desaturate.html
	Filter.MONOCHROME: Basis(
		Vector3(0.22, 0.22, 0.22),
		Vector3(0.72, 0.72, 0.72),
		Vector3(0.06, 0.06, 0.06),
	)
}


@export var filter:Filter = Filter.NONE:
	set(v):
		_filter = v
		if is_node_ready():
			_update_filter()
	get():
		return _filter

var _filter:Filter

@onready var _shader_rect:ColorRect = $ShaderRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_filter()


## Set the active color filter
func _update_filter() -> void:
	_set_color_matrix(COLOR_MATRICES[_filter])
	_shader_rect.visible = Filter.NONE != _filter


## Set the color transformation matrix in the shader
func _set_color_matrix(matrix:Basis) -> void:
	(_shader_rect.material as ShaderMaterial).set_shader_parameter("color_matrix", matrix)
