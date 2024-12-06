extends "res://events/EventZone.gd"

func _on_EventZone_area_entered(_area):
	if state == states.ACTIVE:
		state = states.TRIGGERED
		set_thugs_hostile()

func set_thugs_hostile():
	var thugs = get_tree().get_nodes_in_group("thug")
	
	for thug in thugs:
		thug.behavior.become_hostile()
