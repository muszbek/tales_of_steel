extends Node

var boar
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

func _ready():
	yield(owner, "ready")
	boar = owner
	boar.skin = self
	
	if boar.behavior.druid_event.is_triggered(): set_visible(true)

func start_dead_animate():
	animation_player.stop()
	dead_animate(boar.facing)

func disable_hitbox():
	$AttackPivot/MeleeHitbox/CollisionShape2D.set_deferred("disabled", true)

func idle_animate(facing):
	sprite.animation = "idle_left"
	if facing == boar.directions.LEFT:
		sprite.flip_h = false
	if facing == boar.directions.RIGHT:
		sprite.flip_h = true

func walk_animate(facing):
	sprite.animation = "walk_left"
	if facing == boar.directions.LEFT:
		sprite.flip_h = false
	if facing == boar.directions.RIGHT:
		sprite.flip_h = true

func death_animate(facing):
	if facing == boar.directions.LEFT:
		animation_player.play("death_left")
	if facing == boar.directions.RIGHT:
		animation_player.play("death_right")

func dead_animate(facing):
	sprite.play("dead_left")
	if facing == boar.directions.LEFT:
		sprite.flip_h = false
	if facing == boar.directions.RIGHT:
		sprite.flip_h = true

func set_visible(visible):
	set_deferred("visible", visible)
