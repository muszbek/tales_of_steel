extends Node

enum states {FOLLOWING}

const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor

export var speed: int = 48

onready var player = get_tree().get_nodes_in_group("player")[-1]
var friendly

var state = states.FOLLOWING
var start_facing
var target

func _ready():
	yield(owner, "ready")
	friendly = owner
	friendly.behavior = self
	start_facing = friendly.facing

func call_physics_process(_delta):
	match state:
		states.FOLLOWING:
			var actually_moved = maybe_move_towards_player()
			move_animate(actually_moved, friendly.facing)

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - friendly.global_position
	
	if target_vector.x > 0:
		friendly.facing = friendly.directions.RIGHT
	elif target_vector.x < 0:
		friendly.facing = friendly.directions.LEFT

func maybe_move_towards_player():
	target = player.global_position
	face_towards_target(target)
	
	if should_move_towards_player():
		return move_towards_target(target)
	else:
		return Vector2.ZERO

func move_towards_target(target_pos: Vector2):
	var target_vector = target_pos - friendly.global_position
	var movement_vector = Vector2(0, DEFAULT_GRAVITY)

	if target_vector.x > 0:
		movement_vector.x += speed
	elif target_vector.x < 0:
		movement_vector.x -= speed
	
	return friendly.move_and_slide(movement_vector, FLOOR)

func should_move_towards_player():
	var target_vector = player.global_position - friendly.global_position
	if !player.is_on_floor(): return false
	if abs(target_vector.y) > 1: return false
	if target_vector.length() < friendly.following_distance: return false
	return true

func move_animate(velocity: Vector2, facing):
	if abs(velocity.x) <= 1:
		friendly.skin.idle_animate(facing)
	else:
		friendly.skin.walk_animate(facing)
