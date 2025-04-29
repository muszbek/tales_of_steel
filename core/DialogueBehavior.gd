extends Node2D

const DIALOGUE_DEATH = "res://dialogues/player_death.txt"

onready var game = get_tree().get_nodes_in_group("game")[-1]
onready var dialogue = get_tree().get_nodes_in_group("dialogue")[-1]

var player: KinematicBody2D
var states

signal dialogue(json_resource)

func _ready():
	var _err = connect("dialogue", dialogue, "do_dialogue")
	dialogue.connect("dialogue_started", self, "dialogue_started")
	dialogue.connect("dialogue_finished", self, "dialogue_finished")

func init(owner):
	player = owner
	states = player.behavior.states

func death_dialogue():
	if player.death_dialogue:
		emit_signal("dialogue", player.death_dialogue)
	else:
		emit_signal("dialogue", DIALOGUE_DEATH)

func dialogue_started():
	player.behavior.controls_on = false

func dialogue_finished():
	if player.behavior.state == states.DEAD:
		game.current_chapter.emit_signal("restart")
	else:
		player.behavior.controls_on = true
