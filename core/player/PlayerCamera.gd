extends Node2D

var player: KinematicBody2D
var static_position
var detached = false

func _ready():
	yield(owner, "ready")
	player = owner
	load_parallax()

func _process(_delta):
	if detached:
		set_deferred("global_position", static_position)

func load_parallax():
	var path = player.get_current_map().get_parallax_path()
	do_load_parallax(path)

func do_load_parallax(path):
	var parallax = load(path).instance()
	$Camera2D/BackgroundPlaceholder.add_child(parallax)

func detach_camera():
	static_position = global_position
	detached = true
	$Camera2D.clear_current()
