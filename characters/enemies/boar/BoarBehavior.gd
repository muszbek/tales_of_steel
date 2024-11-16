extends Node

enum states {IDLE, LEFT, RIGHT, DEAD, REMOVED}

const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor

export var speed: int = 48

var boar

onready var player = get_tree().get_nodes_in_group("player")[-1]
onready var left_target = get_tree().get_nodes_in_group("boar_left_target")[-1].global_position
onready var right_target = get_tree().get_nodes_in_group("boar_right_target")[-1].global_position
onready var druid_event = get_tree().get_nodes_in_group("druid_event")[-1]

var state = states.IDLE
var start_pos
var start_facing
var movement_vector: Vector2 = Vector2.ZERO

func _ready():
	yield(owner, "ready")
	boar = owner
	boar.behavior = self
	start_pos = boar.global_position
	start_facing = boar.facing
	
	if druid_event.is_triggered():
		become_hostile()

func call_physics_process(_delta):
	match state:
		states.IDLE:
			boar.facing = start_facing
			boar.skin.idle_animate(boar.facing)
			maybe_start_charging()
		states.LEFT:
			move_towards_target(left_target)
			boar.skin.walk_animate(boar.facing)
			maybe_reached_left_target()
		states.RIGHT:
			move_towards_target(right_target)
			boar.skin.walk_animate(boar.facing)
			maybe_reached_right_target()
		states.DEAD:
			pass

func is_player_in_sight() -> bool:
	boar.los.look_at(player.global_position)
	var collider = boar.los.get_collider()
	return collider and collider.is_in_group("player")

func maybe_start_charging():
	if boar.hostile == boar.hostility.HOSTILE:
		if is_player_in_sight(): state = states.LEFT

func move_towards_target(target_pos: Vector2):
	var target_vector = target_pos - boar.global_position
	movement_vector = Vector2(0, DEFAULT_GRAVITY)

	if target_vector.x > 0:
		movement_vector.x += speed
	elif target_vector.x < 0:
		movement_vector.x -= speed
	
	return boar.move_and_slide(movement_vector, FLOOR)

func maybe_reached_left_target():
	if has_reached_target(left_target):
		face_towards_target(right_target)
		state = states.RIGHT

func maybe_reached_right_target():
	if has_reached_target(right_target):
		face_towards_target(left_target)
		state = states.LEFT

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - boar.global_position
	
	if target_vector.x > 0:
		boar.facing = boar.directions.RIGHT
	elif target_vector.x < 0:
		boar.facing = boar.directions.LEFT

func has_reached_target(target_pos: Vector2):
	return (target_pos - boar.global_position).length() < 4

func death():
	state = states.DEAD
	boar.disable_collisions()
	boar.skin.death_animate(boar.facing)

func spawn():
	boar.skin.set_visible(true)

func become_hostile():
	boar.hostile = boar.hostility.HOSTILE

func is_dead():
	return state == states.DEAD
