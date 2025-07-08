extends KinematicBody2D

onready var shape = $CollisionShape2D

func _ready():
	front()

func front():
	shape.set_deferred("position", Vector2(52, -34))
	shape.set_deferred("rotation_degrees", 30)
	shape.set_deferred("disabled", false)

func up():
	shape.set_deferred("disabled", true)

func down():
	shape.set_deferred("position", Vector2(47, -14.5))
	shape.set_deferred("rotation_degrees", 0)
	shape.set_deferred("disabled", false)
