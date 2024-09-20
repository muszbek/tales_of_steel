extends Node

var ape
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

func _ready():
	yield(owner, "ready")
	ape = owner
	ape.skin = self
	disable_hitbox()

func launch_to_air():
	ape.behavior.launch_to_air()

func finish_attack():
	ape.behavior.finish_attack()

func start_dead_animate():
	animation_player.stop()
	dead_animate(ape.facing)

func disable_hitbox():
	$AttackPivot/MeleeHitbox/CollisionShape2D.set_deferred("disabled", true)

func idle_animate(facing):
	sprite.animation = "idle_left"
	if facing == ape.directions.LEFT:
		sprite.flip_h = false
	if facing == ape.directions.RIGHT:
		sprite.flip_h = true

func death_animate(facing):
	if facing == ape.directions.LEFT:
		animation_player.play("death_left")
	if facing == ape.directions.RIGHT:
		animation_player.play("death_right")

func dead_animate(facing):
	sprite.play("dead_left")
	if facing == ape.directions.LEFT:
		sprite.flip_h = false
	if facing == ape.directions.RIGHT:
		sprite.flip_h = true

func start_attack(facing):
	if facing == ape.directions.LEFT:
		animation_player.play("attack_left")
	if facing == ape.directions.RIGHT:
		animation_player.play("attack_right")

func start_jump(facing):
	if facing == ape.directions.LEFT:
		animation_player.play("jump_left")
	if facing == ape.directions.RIGHT:
		animation_player.play("jump_right")

func air_animate(facing):
	sprite.play("air_left")
	if facing == ape.directions.LEFT:
		sprite.flip_h = false
	if facing == ape.directions.RIGHT:
		sprite.flip_h = true
