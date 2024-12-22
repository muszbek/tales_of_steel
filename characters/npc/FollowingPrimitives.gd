extends Node

var friendly
onready var sprite = $AnimatedSprite

func _ready():
	yield(owner, "ready")
	friendly = owner
	friendly.skin = self

func walk_animate(facing):
	if facing == friendly.directions.LEFT:
		sprite.animation = "walk_left"
		sprite.position = Vector2(-2, 0)
	if facing == friendly.directions.RIGHT:
		sprite.animation = "walk_right"
		sprite.position = Vector2(2, 0)

func idle_animate(facing):
	if facing == friendly.directions.LEFT:
		sprite.animation = "idle_left"
		sprite.position = Vector2(-2, 0)
	if facing == friendly.directions.RIGHT:
		sprite.animation = "idle_right"
		sprite.position = Vector2(2, 0)
