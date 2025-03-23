extends Node

onready var game = get_tree().get_nodes_in_group("game")[-1]

var player

func _ready():
	pass

func init(owner):
	player = owner
	load_on_start()

func save_state():
	return {
		"pos": player.global_position,
		"facing": player.facing
	}

func load_state(dict):
	if not dict:
		return
	
	player.set_deferred("global_position", dict.get("pos"))
	player.facing = dict.get("facing")

func load_on_start():
	var data = game.saved_game.get("Player")
	load_state(data)
