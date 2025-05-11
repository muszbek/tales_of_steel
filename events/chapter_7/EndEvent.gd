extends Node

signal dialogue(json_resource)

const DIALOGUE = "res://dialogues/chapter_7/event_end.txt"

onready var dialogue = get_tree().get_nodes_in_group("dialogue")[-1]
onready var assassin = get_tree().get_nodes_in_group("assassin")[-1]
var json_resource: String = ""

func _ready():
	var _err = connect("dialogue", dialogue, "do_dialogue")
	assassin.connect("assassin_dead", self, "trigger")

func trigger():
	json_resource = DIALOGUE
	emit_signal("dialogue", json_resource)
