extends "res://characters/npc/Character.gd"

enum states {ENTER, LOOP}
const DIALOGUE_1 = "res://dialogues/chapter_0/frontierman_1_1.txt"
var state = 0

func _ready():
	pass # Replace with function body.

func _on_InteractionBox_area_entered(_area):
	match state:
		states.ENTER:
			json_resource = DIALOGUE_1
			interact()
			state = states.LOOP
		states.LOOP:
			json_resource = DIALOGUE_LOOP
			interact()
