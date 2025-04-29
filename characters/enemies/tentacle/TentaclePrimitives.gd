extends Node

var tentacle
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

func _ready():
	yield(owner, "ready")
	tentacle = owner
	tentacle.skin = self
	disable_hitbox()

func finish_attack():
	tentacle.behavior.finish_attack()

func start_dead_animate():
	animation_player.stop()
	dead_animate(tentacle.facing)

func disable_hitbox():
	$AttackPivot/MeleeHitbox/CollisionShape2D.set_deferred("disabled", true)

func idle_animate(facing):
	sprite.animation = "idle_left"
	if facing == tentacle.directions.LEFT:
		sprite.flip_h = false
	if facing == tentacle.directions.RIGHT:
		sprite.flip_h = true

func death_animate(facing):
	if facing == tentacle.directions.LEFT:
		animation_player.play("death_left")
	if facing == tentacle.directions.RIGHT:
		animation_player.play("death_right")

func dead_animate(facing):
	sprite.play("dead_left")
	if facing == tentacle.directions.LEFT:
		sprite.flip_h = false
	if facing == tentacle.directions.RIGHT:
		sprite.flip_h = true

func start_attack(facing):
	if facing == tentacle.directions.LEFT:
		animation_player.play("attack_left")
	if facing == tentacle.directions.RIGHT:
		animation_player.play("attack_right")
