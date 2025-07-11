extends "res://events/EventZone.gd"

onready var snow_effect = get_tree().get_nodes_in_group("snow_effect")[-1]

signal start_snow(script_name)

func _ready():
	var _err = connect("start_snow", snow_effect, "handle_script")
	
	if state == states.TRIGGERED:
		emit_signal("start_snow", "start_snow")
