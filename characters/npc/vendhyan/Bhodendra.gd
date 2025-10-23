extends "res://characters/npc/CharacterTurn.gd"

const SCRIPT_BHODENDRA_ACTIVATE = "activate_bhodendra"

onready var devi = get_tree().get_nodes_in_group("devi")[-1]

func handle_script(script_name):
	if script_name == SCRIPT_BHODENDRA_ACTIVATE:
		activate_self()
	
	if not active: return
	
	if script_name == SCRIPT_TURN_LEFT:
		turn(directions.LEFT)
	elif script_name == SCRIPT_TURN_RIGHT:
		turn(directions.RIGHT)
	else:
		return
	
	$Timer.start()

func activate_self():
	active = true
	dialogue.disconnect("script", devi, "handle_script")
	$Timer.start()
