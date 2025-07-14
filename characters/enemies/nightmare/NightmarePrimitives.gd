extends Node

var enemy
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

func _ready():
	yield(owner, "ready")
	enemy = owner
	enemy.skin = self
	disable_hitbox()

func finish_attack():
	enemy.behavior.finish_attack()

func start_dead_animate():
	animation_player.stop()
	dead_animate(enemy.facing)

func disable_hitbox():
	$AttackPivot/MeleeHitbox/CollisionShape2D.set_deferred("disabled", true)

func walk_animate(facing):
	if facing == enemy.directions.LEFT:
		sprite.animation = "walk_left"
		sprite.position = Vector2(-2, 0)
	if facing == enemy.directions.RIGHT:
		sprite.animation = "walk_right"
		sprite.position = Vector2(2, 0)

func idle_animate(facing):
	if facing == enemy.directions.LEFT:
		sprite.animation = "idle_left"
		sprite.position = Vector2(-2, 0)
	if facing == enemy.directions.RIGHT:
		sprite.animation = "idle_right"
		sprite.position = Vector2(2, 0)

func death_animate(facing):
	if facing == enemy.directions.LEFT:
		animation_player.play("death_left")
	if facing == enemy.directions.RIGHT:
		animation_player.play("death_right")

func dead_animate(facing):
	if facing == enemy.directions.LEFT:
		sprite.play("dead_left")
	if facing == enemy.directions.RIGHT:
		sprite.play("dead_right")

func start_attack(facing):
	if facing == enemy.directions.LEFT:
		animation_player.play("attack_left")
	if facing == enemy.directions.RIGHT:
		animation_player.play("attack_right")
