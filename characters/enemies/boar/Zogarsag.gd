extends Node2D

const SCRIPT_NAME = "transform"
const SCRIPT_NAME_2 = "start_attack"

signal transform_finished

onready var dialogue = get_tree().get_nodes_in_group("dialogue")[-1]
onready var boar = get_tree().get_nodes_in_group("boar_behavior")[-1]
onready var druid_event = get_tree().get_nodes_in_group("druid_event")[-1]

func _ready():
	dialogue.connect("script", self, "handle_script")
	var _err = connect("transform_finished", boar, "spawn")
	$AnimatedSprite.animation = "default"
	
	if druid_event.is_triggered(): disappear()

func handle_script(script_name):
	if script_name == SCRIPT_NAME:
		start_transform()

func start_transform():
	$AnimatedSprite/AnimationPlayer.play("transform")

func transform_finished():
	disappear()
	emit_signal("transform_finished")
	dialogue.emit_signal("next_line")

func disappear():
	set_deferred("visible", false)
