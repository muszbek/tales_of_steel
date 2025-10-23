extends "res://characters/npc/Character.gd"

export var active: bool = true

enum directions {LEFT, RIGHT}
export var facing = directions.LEFT

enum states {IDLE, MOVING, ARRIVED}
var state = states.IDLE

const SCRIPT_START_MOVING = "guard_start_moving"

export var speed: int = 24
export var distance: int = 28

onready var sprite = $AnimatedSprite
onready var devi = get_tree().get_nodes_in_group("devi")[-1]
var target

func _ready():
	dialogue.connect("script", self, "handle_script")
	target = devi.global_position

func _process(delta):
	match state:
		states.IDLE:
			pass
		states.MOVING:
			walk_animate()
			move_towards_target(target, delta)
			maybe_reached_target(target)
		states.ARRIVED:
			pass

func handle_script(script_name):
	if script_name == SCRIPT_START_MOVING: start_moving()

func face_towards_target(target_pos: Vector2):
	var target_vector = target_pos - global_position
	
	if target_vector.x > 0:
		facing = directions.RIGHT
	elif target_vector.x < 0:
		facing = directions.LEFT

func move_towards_target(target_pos: Vector2, delta):
	var target_vector = target_pos - global_position
	var movement_vector = Vector2(0, 0)

	if target_vector.x > 0:
		movement_vector.x += speed * delta
	elif target_vector.x < 0:
		movement_vector.x -= speed * delta
	
	global_position += movement_vector

func maybe_reached_target(target_pos):
	if has_reached_target(target_pos): reached_target()

func has_reached_target(target_pos):
	var target_vector = target_pos - global_position
	return target_vector.length() < distance

func reached_target():
	idle_animate()
	state = states.ARRIVED
	devi.turn(devi.directions.RIGHT)
	dialogue.emit_signal("next_line")

func walk_animate():
	if facing == directions.LEFT:
		sprite.animation = "walk_left"
		sprite.position = Vector2(-6, 0)
	if facing == directions.RIGHT:
		sprite.animation = "walk_right"
		sprite.position = Vector2(6, 0)

func idle_animate():
	if facing == directions.LEFT:
		sprite.animation = "idle_left"
		sprite.position = Vector2(-6, 0)
	if facing == directions.RIGHT:
		sprite.animation = "idle_right"
		sprite.position = Vector2(6, 0)

func start_moving():
	if not active: return
	state = states.MOVING
