extends KinematicBody2D

enum directions {LEFT, RIGHT}

export var following_distance: int = 48
export var facing = directions.LEFT

var skin
var behavior

func _physics_process(delta):
	behavior.call_physics_process(delta)
