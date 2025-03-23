extends Node

enum states {MOVE, ATTACK, JUMP, AIR, DEAD, SCRIPT}

const SPEED = 48
const JUMP_SPEED = 2
const JUMP_MAX_POTENTIAL = 32 ## number of frames you can keep going up
const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor

const JUMP_HEIGHT = 32
const JUMP_TIME_TO_PEAK = 0.5
onready var JUMP_VELOCITY = ((2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK)
onready var JUMP_GRAVITY = ((2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK))

var player: KinematicBody2D

var state = states.MOVE
var movement_vector: Vector2 = Vector2.ZERO
var controls_on = true

var jump_potential = JUMP_MAX_POTENTIAL ## number of frames you can keep going up
var finished_jumping = false ## to prevent jumping again mid-air

var speed_factor = 1.0

func _ready():
	pass

func init(owner):
	player = owner

func process(delta):
	match state:
		states.MOVE:
			maybe_interact()
			facing_from_input()
			var actually_moved = move_on_ground(delta)
			move_animate(actually_moved, player.facing)
			maybe_jump(player.facing)
			maybe_in_air()
			maybe_attack()
		states.JUMP:
			pass
		states.AIR:
			facing_from_input()
			var _actually_moved = move_in_air(delta)
			player.skin.air_animate(player.facing)
			maybe_land()
		states.SCRIPT:
			pass

func is_action_pressed(action):
	return Input.is_action_pressed(action) and controls_on

func is_action_just_pressed(action):
	return Input.is_action_just_pressed(action) and controls_on

func is_on_floor():
	return player.is_on_floor() and !did_collide_with_enemy()

func facing_from_input():
	if is_action_pressed("move_left"):
		player.facing = player.directions.LEFT
	if is_action_pressed("move_right"):
		player.facing = player.directions.RIGHT

func move_by_input(input_velocity: Vector2):
	if is_action_pressed("move_right"):
		input_velocity.x += (SPEED * speed_factor)
	if is_action_pressed("move_left"):
		input_velocity.x -= (SPEED * speed_factor)
	
	return input_velocity

func move_on_ground(_delta):
	movement_vector = Vector2(0, DEFAULT_GRAVITY)
	
	var input_velocity = Vector2.ZERO
	input_velocity = move_by_input(input_velocity)
	
	movement_vector += input_velocity
	return player.move_and_slide(movement_vector, FLOOR)

func move_in_air(delta):
	movement_vector.x = 0
	## movement_vector.y is not reset, need to keep memory for gravity acceleration
	movement_vector = apply_gravity(movement_vector, delta)
	
	var input_velocity = Vector2.ZERO
	input_velocity = move_by_input(input_velocity)
	input_velocity = move_jump(input_velocity)
	
	movement_vector += input_velocity
	return player.move_and_slide(movement_vector, FLOOR)

func apply_gravity(velocity: Vector2, delta):
	if is_on_floor():
		velocity.y = min(0, velocity.y)
	else: 
		velocity.y += JUMP_GRAVITY * delta
	
	return velocity

func move_jump(velocity: Vector2):
	if is_action_pressed("move_up"):
		if jump_potential > 0 and !finished_jumping:
			velocity.y -= JUMP_SPEED
			jump_potential -= 1
	else:
		finished_jumping = true
	
	return velocity

func did_collide_with_enemy():
	var collision = player.get_last_slide_collision()
	if collision:
		return collision.collider.is_in_group("enemy")

func maybe_jump(facing):
	if is_action_pressed("move_up"):
		state = states.JUMP
		player.skin.start_jump(facing)

func maybe_in_air():
	if !is_on_floor():
		state = states.AIR

func launch_to_air():
	state = states.AIR
	movement_vector.y -= JUMP_VELOCITY

func maybe_land():
	if is_on_floor():
		jump_potential = JUMP_MAX_POTENTIAL
		finished_jumping = false
		state = states.MOVE

func maybe_attack():
	if is_action_pressed("attack"):
		state = states.ATTACK
		player.skin.start_attack(player.facing)

func finish_attack():
	state = states.MOVE

func maybe_interact():
	if is_action_just_pressed("interact"):
		player.skin.interact(player.facing)

func death():
	state = states.DEAD
	disable_collisions()
	player.skin.death_animate()
	player.dialogue_behavior.death_dialogue()

func disable_collisions():
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
	player.get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)
	player.skin.disable_hitbox()

func move_animate(velocity: Vector2, facing):
	if abs(velocity.x) <= 1:
		player.skin.idle_animate(facing)
	else:
		player.skin.walk_animate(facing)

func script_state():
	state = states.SCRIPT
