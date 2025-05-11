extends Node

var assassin
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

func _ready():
	yield(owner, "ready")
	assassin = owner
	assassin.skin = self

func start_dead_animate():
	animation_player.stop()
	dead_animate(assassin.facing)

func disable_hitbox():
	$AttackPivot/MeleeHitbox/CollisionShape2D.set_deferred("disabled", true)

func walk_animate(facing):
	if facing == assassin.directions.LEFT:
		sprite.animation = "walk_left"
		sprite.position = Vector2(-2, 0)
	if facing == assassin.directions.RIGHT:
		sprite.animation = "walk_right"
		sprite.position = Vector2(2, 0)

func idle_animate(facing):
	if facing == assassin.directions.LEFT:
		sprite.animation = "idle_left"
		sprite.position = Vector2(-2, 0)
	if facing == assassin.directions.RIGHT:
		sprite.animation = "idle_right"
		sprite.position = Vector2(2, 0)

func death_animate(facing):
	if facing == assassin.directions.LEFT:
		animation_player.play("death_left")
		sprite.position = Vector2(6, 0)
	if facing == assassin.directions.RIGHT:
		animation_player.play("death_right")
		sprite.position = Vector2(-6, 0)

func dead_animate(facing):
	if facing == assassin.directions.LEFT:
		sprite.play("dead_left")
		sprite.position = Vector2(6, 0)
	if facing == assassin.directions.RIGHT:
		sprite.play("dead_right")
		sprite.position = Vector2(-6, 0)

func pose_animate(facing):
	if facing == assassin.directions.LEFT:
		animation_player.play("pose_left")
		sprite.position = Vector2(-2, 0)
	if facing == assassin.directions.RIGHT:
		animation_player.play("pose_right")
		sprite.position = Vector2(2, 0)

func finish_pose():
	assassin.behavior.teleport()

func dead_event():
	assassin.behavior.dead_event()
