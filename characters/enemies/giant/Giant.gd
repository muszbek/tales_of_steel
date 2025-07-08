extends KinematicBody2D

onready var hammer = $Hammer
onready var center = Vector2(76, 0)

var skin
var behavior

signal dead

func _ready():
	pass

func _physics_process(delta):
	behavior.call_physics_process(delta)

func disable_collisions():
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	skin.disable_hitbox()

func _on_Hurtbox_area_entered(_area):
	behavior.death()
