extends "res://characters/npc/Character.gd"

var used: bool = false

onready var game = get_tree().get_nodes_in_group("game")[-1]

func _on_InteractionBox_area_entered(_area):
	save_game()
	json_resource = DIALOGUE_LOOP
	interact()

func save_game():
	if used:
		return
	
	game.save()
	used = true
