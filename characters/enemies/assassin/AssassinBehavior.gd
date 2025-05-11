extends Node

enum states {IDLE, TRACKING, POSE, ABANDON, DEAD, REMOVED}

const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor
const TELEPORT_MAX_RANGE = 64
const TELEPORT_MIN_RANGE = TELEPORT_MAX_RANGE - 2
const TELEPORT_RANGE = 160
const TELEPORT_VECTOR = Vector2(TELEPORT_RANGE, 0)

export var speed: int = 36

onready var player = get_tree().get_nodes_in_group("player")[-1]
onready var smoke_field = player.get_owner()
var assassin

var state = states.IDLE
var start_pos
var start_facing
var target

var smoke_effect = preload("res://misc/effects/SmokeBomb.tscn")

func _ready():
	yield(owner, "ready")
	assassin = owner
	assassin.behavior = self
	start_pos = assassin.global_position
	start_facing = assassin.facing

func call_physics_process(_delta):
	match state:
		states.IDLE:
			assassin.facing = start_facing
			assassin.skin.idle_animate(assassin.facing)
			maybe_start_tracking()
		states.TRACKING:
			var actually_moved = maybe_move_towards_player()
			move_animate(actually_moved, assassin.facing)
			maybe_stop_tracking()
			maybe_teleport(assassin.facing)
		states.POSE:
			pass
		states.ABANDON:
			assassin.skin.idle_animate(assassin.facing)
		states.DEAD:
			pass

func is_player_in_sight() -> bool:
	assassin.los.look_at(player.global_position)
	var collider = assassin.los.get_collider()
	return collider and collider.is_in_group("player")

func distance_from_player() -> float:
	return (player.global_position - assassin.global_position).length()

func maybe_start_tracking():
	if is_player_in_sight(): state = states.TRACKING

func maybe_stop_tracking():
	if is_player_dead(): state = states.ABANDON

func is_player_dead():
	return player.behavior.state == player.behavior.states.DEAD

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - assassin.global_position
	
	if target_vector.x > 0:
		assassin.facing = assassin.directions.RIGHT
	elif target_vector.x < 0:
		assassin.facing = assassin.directions.LEFT

func maybe_move_towards_player():
	target = player.global_position
	face_towards_target(target)
	
	if should_move_towards_player():
		return move_towards_target(target)
	else:
		return Vector2.ZERO

func move_towards_target(target_pos: Vector2):
	var target_vector = target_pos - assassin.global_position
	var movement_vector = Vector2(0, DEFAULT_GRAVITY)

	if target_vector.x > 0:
		movement_vector.x += speed
	elif target_vector.x < 0:
		movement_vector.x -= speed
	
	return assassin.move_and_slide(movement_vector, FLOOR)

func should_move_towards_player():
	if assassin.hostile == assassin.hostility.PASSIVE: return false
	var target_vector = player.global_position - assassin.global_position
	if !player.is_on_floor(): return false
	if abs(target_vector.y) > 1: return false
	return true

func move_animate(velocity: Vector2, facing):
	if abs(velocity.x) <= 1:
		assassin.skin.idle_animate(facing)
	else:
		assassin.skin.walk_animate(facing)

func maybe_teleport(facing):
	if should_teleport():
		state = states.POSE
		spawn_smoke()
		assassin.skin.pose_animate(facing)

func should_teleport():
	return is_in_teleport_range() and is_facing_player()

func is_facing_player():
	return assassin.facing != player.facing

func is_in_teleport_range():
	var distance = distance_from_player()
	return distance < TELEPORT_MAX_RANGE and distance > TELEPORT_MIN_RANGE

func spawn_smoke():
	var smoke_instance = smoke_effect.instance()
	smoke_instance.position = assassin.get_global_position()
	smoke_field.add_child(smoke_instance)

func teleport():
	var target_vector = player.global_position - assassin.global_position
	
	if target_vector.x > 0:
		assassin.set_deferred("global_position", assassin.global_position + TELEPORT_VECTOR)
	else:
		assassin.set_deferred("global_position", assassin.global_position - TELEPORT_VECTOR)
	
	state = states.TRACKING

func death():
	state = states.DEAD
	assassin.disable_collisions()
	assassin.skin.death_animate(assassin.facing)

func dead_event():
	if not is_player_dead():
		assassin.emit_signal("dead")

func become_hostile():
	assassin.hostile = assassin.hostility.HOSTILE
