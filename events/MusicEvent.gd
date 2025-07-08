extends Area2D

enum states {ACTIVE, TRIGGERED}

signal start_music(title_to_start)

onready var music = get_tree().get_nodes_in_group("music")[-1]
onready var game = get_tree().get_nodes_in_group("game")[-1]
export var TITLE: String
export var only_once: bool = true
var state = states.ACTIVE

func _ready():
	var _err = connect("start_music", music, "on_start_music")
	load_on_start()

func trigger():
	if state == states.ACTIVE:
		state = states.TRIGGERED
		$CollisionShape2D.set_deferred("disabled", true)
		emit_signal("start_music", TITLE)

func _on_MusicEvent_area_entered(_area):
	if TITLE:
		trigger()
		if only_once: game.save_event(self)

func save_state():
	return {"state": state}

func load_state(dict):
	if not dict:
		return

	state = dict.get("state")

func load_on_start():
	var data = game.saved_game.get(get_name())
	load_state(data)
