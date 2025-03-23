extends Node2D

const PLAYER_SKIN_SCENE_075 = "res://core/player/PlayerSkin075.tscn"
const SCRIPT_NAME_075 = "lotus_075"
const PLAYER_SKIN_SCENE_050 = "res://core/player/PlayerSkin050.tscn"
const SCRIPT_NAME_050 = "lotus_050"
const PLAYER_SKIN_SCENE_025 = "res://core/player/PlayerSkin025.tscn"
const SCRIPT_NAME_025 = "lotus_025"

const SCRIPT_NAME_COLLAPSE = "collapse"

onready var player = get_tree().get_nodes_in_group("player")[-1]
onready var dialogue = get_tree().get_nodes_in_group("dialogue")[-1]
onready var parallax = get_tree().get_nodes_in_group("parallax")[-1]

signal change_parallax

func _ready():
	dialogue.connect("script", self, "handle_script")
	var _err = connect("change_parallax", parallax, "start_vibration")

func handle_script(script_name):
	if script_name == SCRIPT_NAME_075:
		switch_skin(PLAYER_SKIN_SCENE_075, 0.75)
	elif script_name == SCRIPT_NAME_050:
		switch_skin(PLAYER_SKIN_SCENE_050, 0.5)
		emit_signal("change_parallax", 2)
	elif script_name == SCRIPT_NAME_025:
		switch_skin(PLAYER_SKIN_SCENE_025, 0.25)
		emit_signal("change_parallax", 1)
		player.skin.connect("death_anim_finished", self, "collapse_finished")
	elif script_name == SCRIPT_NAME_COLLAPSE:
		player.behavior.script_state()
		player.skin.death_animate()
		return
	
	$Timer.start()

func switch_skin(skin_scene_path, factor):
	var new_skin_scene = load(skin_scene_path)
	var old_skin = player.get_node("PlayerSkin")
	var new_skin = new_skin_scene.instance()
	new_skin.name = "PlayerSkin"
	player.call_deferred("remove_child", old_skin)
	player.call_deferred("add_child", new_skin)
	player.skin = new_skin
	player.skin.init(player)
	player.behavior.set_deferred("speed_factor", factor)
	old_skin.queue_free()

func _on_Timer_timeout():
	dialogue.emit_signal("next_line")

func collapse_finished():
	dialogue.emit_signal("next_line")
