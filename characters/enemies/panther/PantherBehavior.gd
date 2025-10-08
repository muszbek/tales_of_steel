extends Node

enum states {IDLE, TRACKING, ABANDON, AIR, DEAD, REMOVED}

const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor
const JUMP_DISTANCE = 56

export var speed: int = 24
export var jump_speed: int = 48

onready var player = get_tree().get_nodes_in_group("player")[-1]
onready var JUMP_GRAVITY = player.behavior.JUMP_GRAVITY
onready var FRAMERATE = ProjectSettings.get_setting("physics/common/physics_fps")
var panther

var state = states.IDLE
var start_pos
var start_facing
var target
var movement_vector: Vector2 = Vector2.ZERO

func _ready():
	yield(owner, "ready")
	panther = owner
	panther.behavior = self
	start_pos = panther.global_position
	start_facing = panther.facing

func call_physics_process(delta):
	match state:
		states.IDLE:
			panther.facing = start_facing
			panther.skin.idle_animate(panther.facing)
			maybe_start_tracking()
		states.TRACKING:
			maybe_stop_tracking()
			maybe_move_towards_player()
			maybe_jump_towards_player()
		states.ABANDON:
			maybe_start_tracking()
			move_tovards_base()
			maybe_reached_target(target)
		states.AIR:
			move_in_air(delta)
			panther.skin.air_animate(panther.facing)
			maybe_land()
		states.DEAD:
			if should_move_corpse(): move_in_air(delta)

func is_player_in_sight() -> bool:
	panther.los.look_at(player.global_position)
	var collider = panther.los.get_collider()
	return collider and collider.is_in_group("player") and player.is_alive()

func distance_from_player() -> float:
	return (player.global_position - panther.global_position).length()

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
		$Timer.start()
		panther.skin.disable_hitbox()

func is_on_floor():
	return panther.is_on_floor() and !did_collide_with_player()

func did_collide_with_player():
	var collision = panther.get_last_slide_collision()
	if collision:
		return collision.collider.is_in_group("player")

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - panther.global_position
	
	if target_vector.x > 0:
		panther.facing = panther.directions.RIGHT
	elif target_vector.x < 0:
		panther.facing = panther.directions.LEFT

func maybe_move_towards_player():
	target = player.global_position
	face_towards_target(target)
	
	if should_move_towards_player():
		move_towards_target(target)
		panther.skin.walk_animate(panther.facing)
	else:
		panther.skin.idle_animate(panther.facing)

func should_move_towards_player():
	if !player.is_on_floor(): return false
	if (panther.global_position - start_pos).length() >= panther.max_distance: return false
	return true

func maybe_jump_towards_player():
	if should_jump_towards_player():
		panther.skin.start_attack(panther.facing)
		launch_to_air()

func should_jump_towards_player():
	if state != states.TRACKING: return false
	if $Timer.time_left > 0: return false
	if !player.is_on_floor(): return false
	if distance_from_player() > JUMP_DISTANCE: return false
	return true

func move_tovards_base():
	target = start_pos
	face_towards_target(target)
	move_towards_target(target)
	panther.skin.walk_animate(panther.facing)

func move_towards_target(target_pos: Vector2):
	var target_vector = target_pos - panther.global_position
	movement_vector = Vector2(0, DEFAULT_GRAVITY)
	
	if target_vector.x > 0:
		movement_vector.x += speed
	elif target_vector.x < 0:
		movement_vector.x -= speed
	
	panther.move_and_slide(movement_vector, FLOOR)

func should_move_corpse():
	return panther.global_position.y < start_pos.y

func has_reached_target(target_pos: Vector2):
	return (target_pos - panther.global_position).length() < 4

func finish_attack():
	state = states.IDLE

func death():
	state = states.DEAD
	panther.disable_collisions()
	panther.skin.death_animate(panther.facing)

func apply_gravity(velocity: Vector2, delta):
	if is_on_floor():
		velocity.y = min(0, velocity.y)
	else: 
		velocity.y += JUMP_GRAVITY * delta
	
	return velocity

func move_in_air(delta):
	## movement_vector is not reset, need to keep memory for gravity acceleration
	movement_vector = apply_gravity(movement_vector, delta)
	return panther.move_and_slide(movement_vector, FLOOR)

func launch_to_air():
	var x
	var y
	
	if panther.facing == panther.directions.LEFT:
		x = -jump_speed
	if panther.facing == panther.directions.RIGHT:
		x = jump_speed
	
	y = -calculate_jump_impulse(target)
	
	movement_vector = Vector2(x, y)
	state = states.AIR

func calculate_jump_impulse(jump_target):
	## distance = speed * t * 2
	## impulse = gravity * t^2
	## 0 = impulse * t^2 - speed * t
	## 0 = t * (impulse * t - speed)
	var target_vector = jump_target - panther.global_position
	var distance = abs(target_vector.x)
	var t = distance / jump_speed / 2
	return clamp(t * t * JUMP_GRAVITY, 64, 128)
