extends KinematicBody2D

enum directions {LEFT, RIGHT}
enum hostility {PASSIVE, HOSTILE}

export var max_distance: int = 64
export var facing = directions.LEFT
export var hostile = hostility.HOSTILE

onready var los = $LineOfSight

var skin
var behavior

func _ready():
	$LineOfSight.set_cast_to(Vector2(max_distance, 0))

func _physics_process(delta):
	behavior.call_physics_process(delta)

func disable_collisions():
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	skin.disable_hitbox()

func _on_Hurtbox_area_entered(_area):
	behavior.death()
