extends Node

enum states {IDLE, ATTACK, RECOVER, DEAD, REMOVED}

const ATTACK_DISTANCE = 36

onready var player = get_tree().get_nodes_in_group("player")[-1]
var tentacle

var state = states.IDLE
var start_pos
var start_facing
var target

func _ready():
	yield(owner, "ready")
	tentacle = owner
	tentacle.behavior = self
	start_pos = tentacle.global_position
	start_facing = tentacle.facing

func call_physics_process(_delta):
	match state:
		states.IDLE:
			tentacle.facing = start_facing
			tentacle.skin.idle_animate(tentacle.facing)
			attack_when_close_enough()
		states.RECOVER:
			tentacle.facing = start_facing
			tentacle.skin.idle_animate(tentacle.facing)
		states.ATTACK:
			pass
		states.DEAD:
			pass

func is_player_in_sight() -> bool:
	tentacle.los.look_at(player.global_position)
	var collider = tentacle.los.get_collider()
	return collider and collider.is_in_group("player")

func distance_from_player() -> float:
	return (player.global_position - tentacle.global_position).length()

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - tentacle.global_position
	
	if target_vector.x > 0:
		tentacle.facing = tentacle.directions.RIGHT
	elif target_vector.x < 0:
		tentacle.facing = tentacle.directions.LEFT

func attack_when_close_enough():
	if is_player_in_sight():
		target = player.global_position
		face_towards_target(target)
		
		if distance_from_player() < ATTACK_DISTANCE: attack()

func attack():
	state = states.ATTACK
	tentacle.skin.start_attack(tentacle.facing)

func finish_attack():
	state = states.RECOVER
	$RecoveryTimer.start()

func death():
	state = states.DEAD
	tentacle.disable_collisions()
	tentacle.skin.death_animate(tentacle.facing)

func _on_RecoveryTimer_timeout():
	if state != states.DEAD:
		state = states.IDLE
