extends Node2D

const TITLE = "res://assets/music/end_ambient_1.mp3"

func _ready():
	var music = get_tree().get_nodes_in_group("music")[-1]
	music.play_soundtrack(TITLE)
