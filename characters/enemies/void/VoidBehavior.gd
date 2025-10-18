extends Node

enum states {IDLE, TRACKING, ABANDON, DEAD, REMOVED}

const FLOOR = Vector2(0, -1)
const DEFAULT_GRAVITY = 10 ## just some value to make body collide with the floor

export var speed: int = 24

onready var player = get_tree().get_nodes_in_group("player")[-1]
var vvoid

var state = states.IDLE
var start_pos
var start_facing
var target
var movement_vector: Vector2 = Vector2.ZERO

func _ready():
	yield(owner, "ready")
	vvoid = owner
	vvoid.behavior = self
	start_pos = vvoid.global_position

func call_physics_process(_delta):
	match state:
		states.IDLE:
			vvoid.skin.idle_animate()
			maybe_start_tracking()
		states.TRACKING:
			maybe_stop_tracking()
			maybe_move_towards_player()
		states.ABANDON:
			maybe_start_tracking()
			move_tovards_base()
			maybe_reached_target(target)
		states.DEAD:
			pass

func is_player_in_sight() -> bool:
	vvoid.los.look_at(player.global_position)
	var collider = vvoid.los.get_collider()
	return collider and collider.is_in_group("player") and player.is_alive()

func distance_from_player() -> float:
	return (player.global_position - vvoid.global_position).length()

func maybe_start_tracking():
	if is_player_in_sight(): state = states.TRACKING

func maybe_stop_tracking():
	if !is_player_in_sight(): state = states.ABANDON

func maybe_reached_target(target_pos):
	if has_reached_target(target_pos): state = states.IDLE

func maybe_move_towards_player():
	target = player.global_position
	
	if should_move_towards_player():
		move_towards_target(target)
		vvoid.skin.walk_animate()
	else:
		vvoid.skin.idle_animate()

func should_move_towards_player():
	if !player.is_on_floor(): return false
	if (vvoid.global_position - start_pos).length() >= vvoid.max_distance: return false
	return true

func move_tovards_base():
	target = start_pos
	move_towards_target(target)
	vvoid.skin.walk_animate()

func move_towards_target(target_pos: Vector2):
	var target_vector = target_pos - vvoid.global_position
	movement_vector = Vector2(0, DEFAULT_GRAVITY)
	
	if target_vector.x > 0:
		movement_vector.x += speed
	elif target_vector.x < 0:
		movement_vector.x -= speed
	
	vvoid.move_and_slide(movement_vector, FLOOR)

func has_reached_target(target_pos: Vector2):
	return (target_pos - vvoid.global_position).length() < 4

func death():
	state = states.DEAD
	vvoid.disable_collisions()
	vvoid.skin.death_animate()
