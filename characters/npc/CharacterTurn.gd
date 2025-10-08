extends "res://characters/npc/Character.gd"

enum directions {LEFT, RIGHT}
const SCRIPT_TURN_LEFT = "turn_left"
const SCRIPT_TURN_RIGHT = "turn_right"

export var facing = directions.LEFT
export var active: bool = false

onready var sprite = $AnimatedSprite

func _ready():
	dialogue.connect("script", self, "handle_script")
	turn(facing)

func handle_script(script_name):
	if not active: return
	
	if script_name == SCRIPT_TURN_LEFT:
		turn(directions.LEFT)
	elif script_name == SCRIPT_TURN_RIGHT:
		turn(directions.RIGHT)
	
	$Timer.start()

func turn(direction):
	if direction == directions.LEFT:
		sprite.animation = "idle_left"
		sprite.position = Vector2(-2, 0)
	if direction == directions.RIGHT:
		sprite.animation = "idle_right"
		sprite.position = Vector2(2, 0)

func _on_Timer_timeout():
	dialogue.emit_signal("next_line")
