extends Node2D

var player: KinematicBody2D
var static_position
var detached = false

func _ready():
	yield(owner, "ready")
	player = owner

func _process(_delta):
	if detached:
		set_deferred("global_position", static_position)

func detach_camera():
	static_position = global_position
	detached = true
	$Camera2D.clear_current()
