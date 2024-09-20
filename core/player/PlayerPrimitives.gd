extends Node2D

var player
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var interaction_player = $InteractPivot/Interactbox/CollisionShape2D/InteractionPlayer

func _ready():
	yield(owner, "ready")
	player = owner
	player.skin = self
	disable_hitbox()
	disable_interactbox()

func launch_to_air():
	player.behavior.launch_to_air()

func finish_attack():
	player.behavior.finish_attack()

func dead_animate():
	animation_player.stop()
	sprite.play("dead")

func disable_hitbox():
	$AttackPivot/MeleeHitbox/CollisionShape2D.set_deferred("disabled", true)

func disable_interactbox():
	$InteractPivot/Interactbox/CollisionShape2D.set_deferred("disabled", true)

func air_animate(facing):
	if facing == player.directions.LEFT:
		sprite.animation = "air_left"
		sprite.position = Vector2(-2, 0)
	if facing == player.directions.RIGHT:
		sprite.animation = "air_right"
		sprite.position = Vector2(2, 0)

func walk_animate(facing):
	if facing == player.directions.LEFT:
		sprite.animation = "walk_left"
		sprite.position = Vector2(-2, 0)
	if facing == player.directions.RIGHT:
		sprite.animation = "walk_right"
		sprite.position = Vector2(2, 0)

func idle_animate(facing):
	if facing == player.directions.LEFT:
		sprite.animation = "idle_left"
		sprite.position = Vector2(-2, 0)
	if facing == player.directions.RIGHT:
		sprite.animation = "idle_right"
		sprite.position = Vector2(2, 0)

func death_animate():
	sprite.position = Vector2(2, 0)
	animation_player.play("death_right")

func start_jump(facing):
	if facing == player.directions.LEFT:
		animation_player.play("jump_left")
	if facing == player.directions.RIGHT:
		animation_player.play("jump_right")

func start_attack(facing):
	if facing == player.directions.LEFT:
		animation_player.play("attack_left")
	if facing == player.directions.RIGHT:
		animation_player.play("attack_right")

func interact(facing):
	if facing == player.directions.LEFT:
		interaction_player.play("interact_left")
	if facing == player.directions.RIGHT:
		interaction_player.play("interact_right")
