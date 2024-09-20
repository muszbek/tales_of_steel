extends Node

enum states {IDLE, TRACKING, ABANDON, JUMP, AIR, ATTACK, DEAD, REMOVED}

const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor
const ATTACK_DISTANCE = 32
const JUMP_DISTANCE = 48

export var speed: int = 48

onready var player = get_tree().get_nodes_in_group("player")[-1]
onready var JUMP_GRAVITY = player.behavior.JUMP_GRAVITY
onready var FRAMERATE = ProjectSettings.get_setting("physics/common/physics_fps")
var ape

var state = states.IDLE
var start_pos
var start_facing
var target
var movement_vector: Vector2 = Vector2.ZERO

func _ready():
	yield(owner, "ready")
	ape = owner
	ape.behavior = self
	start_pos = ape.global_position
	start_facing = ape.facing

func call_physics_process(delta):
	match state:
		states.IDLE:
			ape.facing = start_facing
			ape.skin.idle_animate(ape.facing)
			maybe_start_tracking()
		states.TRACKING:
			maybe_stop_tracking()
			maybe_move_towards_player()
			ape.skin.idle_animate(ape.facing)
			attack_when_close_enough()
		states.ABANDON:
			maybe_start_tracking()
			move_tovards_base()
			ape.skin.idle_animate(ape.facing)
			maybe_reached_target(target)
		states.JUMP:
			pass
		states.AIR:
			move_in_air(delta)
			ape.skin.air_animate(ape.facing)
			maybe_land()
		states.ATTACK:
			pass
		states.DEAD:
			pass

func is_player_in_sight() -> bool:
	ape.los.look_at(player.global_position)
	var collider = ape.los.get_collider()
	return collider and collider.is_in_group("player")

func distance_from_player() -> float:
	return (player.global_position - ape.global_position).length()

func maybe_start_tracking():
	if is_player_in_sight(): state = states.TRACKING

func maybe_stop_tracking():
	if !is_player_in_sight(): state = states.ABANDON

func maybe_reached_target(target_pos):
	if has_reached_target(target_pos): state = states.IDLE

func maybe_land():
	if is_on_floor():
		movement_vector = Vector2.ZERO
		state = states.TRACKING

func is_on_floor():
	return ape.is_on_floor() and !did_collide_with_player()

func did_collide_with_player():
	var collision = ape.get_last_slide_collision()
	if collision:
		return collision.collider.is_in_group("player")

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - ape.global_position
	
	if target_vector.x > 0:
		ape.facing = ape.directions.RIGHT
	elif target_vector.x < 0:
		ape.facing = ape.directions.LEFT

func maybe_move_towards_player():
	target = player.global_position
	face_towards_target(target)
	
	if should_move_towards_player():
		jump(ape.facing)

func should_move_towards_player():
	if !player.is_on_floor(): return false
	if (ape.global_position - start_pos).length() >= ape.max_distance: return false
	if distance_from_player() < JUMP_DISTANCE: return false
	return true

func move_tovards_base():
	target = start_pos
	face_towards_target(target)
	jump(ape.facing)

func has_reached_target(target_pos: Vector2):
	return (target_pos - ape.global_position).length() < 4

func attack_when_close_enough():
	if distance_from_player() < ATTACK_DISTANCE: attack()

func attack():
	state = states.ATTACK
	ape.skin.start_attack(ape.facing)

func finish_attack():
	state = states.IDLE

func death():
	state = states.DEAD
	ape.disable_collisions()
	ape.skin.death_animate(ape.facing)

func jump(facing):
	ape.skin.start_jump(facing)
	state = states.JUMP

func apply_gravity(velocity: Vector2, delta):
	if is_on_floor():
		velocity.y = min(0, velocity.y)
	else: 
		velocity.y += JUMP_GRAVITY * delta
	
	return velocity

func move_in_air(delta):
	## movement_vector is not reset, need to keep memory for gravity acceleration
	movement_vector = apply_gravity(movement_vector, delta)
	return ape.move_and_slide(movement_vector, FLOOR)

func launch_to_air():
	var x
	var y
	
	if ape.facing == ape.directions.LEFT:
		x = -speed
	if ape.facing == ape.directions.RIGHT:
		x = speed
	
	y = -calculate_jump_impulse(target)
	
	movement_vector = Vector2(x, y)
	state = states.AIR

func calculate_jump_impulse(jump_target):
	## distance = speed * t * 2
	## impulse = gravity * t^2
	## 0 = impulse * t^2 - speed * t
	## 0 = t * (impulse * t - speed)
	## 0 = 
	var target_vector = jump_target - ape.global_position
	var distance = abs(target_vector.x)
	var t = distance / speed / 2
	return clamp(t * t * JUMP_GRAVITY, 128, 256)
