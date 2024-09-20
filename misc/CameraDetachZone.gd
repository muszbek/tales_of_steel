extends Area2D

onready var player = get_tree().get_nodes_in_group("player")[-1]
signal detach_camera

func _ready():
	var _err = connect("detach_camera", player, "on_detach_camera")

func _on_CameraDetachZone1x_area_entered(_area):
	emit_signal("detach_camera")
