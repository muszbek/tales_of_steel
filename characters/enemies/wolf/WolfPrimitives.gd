extends Node

var wolf
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $AttackPivot/MeleeHitbox/CollisionShape2D

func _ready():
	yield(owner, "ready")
	wolf = owner
	wolf.skin = self
	disable_hitbox()

func start_dead_animate():
	animation_player.stop()
	dead_animate(wolf.facing)

func disable_hitbox():
	hitbox.set_deferred("disabled", true)

func idle_animate(facing):
	sprite.animation = "idle_left"
	if facing == wolf.directions.LEFT:
		sprite.flip_h = false
		sprite.position = Vector2(-2, 0)
	if facing == wolf.directions.RIGHT:
		sprite.flip_h = true
		sprite.position = Vector2(2, 0)

func walk_animate(facing):
	sprite.animation = "walk_left"
	if facing == wolf.directions.LEFT:
		sprite.flip_h = false
		sprite.position = Vector2(-2, 0)
	if facing == wolf.directions.RIGHT:
		sprite.flip_h = true
		sprite.position = Vector2(2, 0)

func air_animate(facing):
	sprite.play("air_left")
	if facing == wolf.directions.LEFT:
		sprite.flip_h = false
		sprite.position = Vector2(-2, 0)
	if facing == wolf.directions.RIGHT:
		sprite.flip_h = true
		sprite.position = Vector2(2, 0)

func start_attack(facing):
	if facing == wolf.directions.LEFT:
		hitbox.set_deferred("position", Vector2(-9, 6))
	if facing == wolf.directions.RIGHT:
		hitbox.set_deferred("position", Vector2(9, 6))
	
	hitbox.set_deferred("disabled", false)

func death_animate(facing):
	if facing == wolf.directions.LEFT:
		animation_player.play("death_left")
		sprite.position = Vector2(-2, 0)
	if facing == wolf.directions.RIGHT:
		animation_player.play("death_right")
		sprite.position = Vector2(2, 0)

func dead_animate(facing):
	sprite.play("dead_left")
	if facing == wolf.directions.LEFT:
		sprite.flip_h = false
		sprite.position = Vector2(-2, 0)
	if facing == wolf.directions.RIGHT:
		sprite.flip_h = true
		sprite.position = Vector2(2, 0)
