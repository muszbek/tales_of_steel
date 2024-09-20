extends Node

enum states {IDLE, TRACKING, ABANDON, ATTACK, DEAD, REMOVED}

const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor
const ATTACK_DISTANCE = 24

export var speed: int = 24

onready var player = get_tree().get_nodes_in_group("player")[-1]
var enemy

var state = states.IDLE
var start_pos
var start_facing
var target

func _ready():
	yield(owner, "ready")
	enemy = owner
	enemy.behavior = self
	start_pos = enemy.global_position
	start_facing = enemy.facing

func call_physics_process(_delta):
	match state:
		states.IDLE:
			enemy.facing = start_facing
			enemy.skin.idle_animate(enemy.facing)
			maybe_start_tracking()
		states.TRACKING:
			maybe_stop_tracking()
			var actually_moved = maybe_move_towards_player()
			move_animate(actually_moved, enemy.facing)
			attack_when_close_enough()
		states.ABANDON:
			maybe_start_tracking()
			var actually_moved = move_tovards_base()
			move_animate(actually_moved, enemy.facing)
			maybe_reached_target(target)
		states.ATTACK:
			pass
		states.DEAD:
			pass

func is_player_in_sight() -> bool:
	enemy.los.look_at(player.global_position)
	var collider = enemy.los.get_collider()
	return collider and collider.is_in_group("player")

func distance_from_player() -> float:
	return (player.global_position - enemy.global_position).length()

func maybe_start_tracking():
	if is_player_in_sight(): state = states.TRACKING

func maybe_stop_tracking():
	if !is_player_in_sight(): state = states.ABANDON

func maybe_reached_target(target_pos):
	if has_reached_target(target_pos): state = states.IDLE

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - enemy.global_position
	
	if target_vector.x > 0:
		enemy.facing = enemy.directions.RIGHT
	elif target_vector.x < 0:
		enemy.facing = enemy.directions.LEFT

func maybe_move_towards_player():
	target = player.global_position
	face_towards_target(target)
	
	if should_move_towards_player():
		return move_towards_target(target)
	else:
		return Vector2.ZERO

func move_tovards_base():
	target = start_pos
	face_towards_target(target)
	return move_towards_target(target)

func move_towards_target(target_pos: Vector2):
	var target_vector = target_pos - enemy.global_position
	var movement_vector = Vector2(0, DEFAULT_GRAVITY)

	if target_vector.x > 0:
		movement_vector.x += speed
	elif target_vector.x < 0:
		movement_vector.x -= speed
	
	return enemy.move_and_slide(movement_vector, FLOOR)

func should_move_towards_player():
	var target_vector = player.global_position - enemy.global_position
	if !player.is_on_floor(): return false
	if abs(target_vector.y) > 1: return false
	if (enemy.global_position - start_pos).length() >= enemy.max_distance: return false
	return true

func has_reached_target(target_pos: Vector2):
	return (target_pos - enemy.global_position).length() < 4

func move_animate(velocity: Vector2, facing):
	if abs(velocity.x) <= 1:
		enemy.skin.idle_animate(facing)
	else:
		enemy.skin.walk_animate(facing)

func attack_when_close_enough():
	if distance_from_player() < ATTACK_DISTANCE: attack()

func attack():
	state = states.ATTACK
	enemy.skin.start_attack(enemy.facing)

func finish_attack():
	state = states.IDLE

func death():
	state = states.DEAD
	enemy.disable_collisions()
	enemy.skin.death_animate(enemy.facing)
