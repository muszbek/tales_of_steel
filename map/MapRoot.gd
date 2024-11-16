extends Node2D

export var parallax_path: String = ""

func _ready():
	pass # Replace with function body.

func get_parallax_path():
	if parallax_path:
		return parallax_path
	else:
		push_error("parallax path string must be set!")
