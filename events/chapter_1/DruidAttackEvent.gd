extends "res://events/EventZone.gd"

onready var boar = get_tree().get_nodes_in_group("boar_behavior")[-1]

signal start_attack

func _ready():
	var _err = connect("start_attack", boar, "become_hostile")
	
func _on_EventZone_area_entered(_area):
	if state == states.ACTIVE:
		state = states.TRIGGERED
		emit_signal("start_attack")
