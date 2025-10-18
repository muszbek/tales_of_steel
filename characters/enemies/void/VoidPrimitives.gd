extends Node

var vvoid
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $MeleeHitbox/CollisionShape2D

func _ready():
	yield(owner, "ready")
	vvoid = owner
	vvoid.skin = self

func start_dead_animate():
	animation_player.stop()
	dead_animate()

func disable_hitbox():
	hitbox.set_deferred("disabled", true)

func idle_animate():
	sprite.animation = "idle"

func walk_animate():
	sprite.animation = "walk"

func death_animate():
	animation_player.play("death")

func dead_animate():
	sprite.play("dead")
