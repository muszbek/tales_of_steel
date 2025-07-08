extends Node

var giant
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

func _ready():
	yield(owner, "ready")
	giant = owner
	giant.skin = self
	disable_hitbox()

func finish_attack():
	struck_animate()
	giant.behavior.finish_attack()

func finish_recover():
	giant.behavior.finish_recover()

func start_death_animate():
	sprite.offset = Vector2(32, 0)
	animation_player.stop()
	animation_player.play("death")

func disable_hitbox():
	$MeleeHitbox/CollisionShape2D.set_deferred("disabled", true)

func idle_animate():
	sprite.animation = "idle"

func dead_animate():
	sprite.offset = Vector2(32, 0)
	sprite.play("dead")

func start_attack():
	animation_player.play("attack")

func struck_animate():
	sprite.animation = "struck"

func start_recover():
	animation_player.play("recover")
