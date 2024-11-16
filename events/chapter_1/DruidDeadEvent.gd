extends "res://events/EventZone.gd"

onready var boar = get_tree().get_nodes_in_group("boar_behavior")[-1]

func _ready():
	pass # Replace with function body.

func _on_EventZone_area_entered(_area):
	if not boar.is_dead(): return

	if DIALOGUE:
		json_resource = DIALOGUE
		trigger()
