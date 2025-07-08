extends Node2D

const SCRIPT_NAME_START = "start_snow"
const SCRIPT_NAME_STOP = "stop_snow"

onready var dialogue = get_tree().get_nodes_in_group("dialogue")[-1]
onready var parallax = get_tree().get_nodes_in_group("parallax")[-1]

signal change_parallax_start
signal change_parallax_stop

func _ready():
	dialogue.connect("script", self, "handle_script")
	var _err = connect("change_parallax_start", parallax, "start_snow")
	_err = connect("change_parallax_stop", parallax, "stop_snow")

func handle_script(script_name):
	if script_name == SCRIPT_NAME_START:
		emit_signal("change_parallax_start")
	elif script_name == SCRIPT_NAME_STOP:
		emit_signal("change_parallax_stop")
	
	$Timer.start()

func _on_Timer_timeout():
	dialogue.emit_signal("next_line")
