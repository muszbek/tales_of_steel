extends "res://characters/npc/Character.gd"

enum states {ENTER, LOOP}
var state = states.ENTER

const DIALOGUE_1 = "res://dialogues/chapter_4/kozak_1.txt"

func _ready():
	DIALOGUE_LOOP = "res://dialogues/chapter_4/kozak_loop.txt"

func _on_InteractionBox_area_entered(_area):
	match state:
		states.ENTER:
			json_resource = DIALOGUE_1
			interact()
			state = states.LOOP
		states.LOOP:
			json_resource = DIALOGUE_LOOP
			interact()
