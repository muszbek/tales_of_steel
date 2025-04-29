extends KinematicBody2D

enum directions {LEFT, RIGHT}

export var facing = directions.RIGHT
export var death_dialogue = ""

onready var camera = $PlayerCamera
onready var behavior = $PlayerBehavior
onready var dialogue_behavior = $DialogueBehavior
onready var save_behavior = $PlayerSave
onready var skin = $PlayerSkin

func _ready():
	camera.init(self)
	behavior.init(self)
	dialogue_behavior.init(self)
	save_behavior.init(self)
	skin.init(self)

func _process(delta):
	behavior.process(delta)


func _on_Hurtbox_area_entered(_area):
	behavior.death()
	#pass

func on_detach_camera():
	camera.detach_camera()

func get_current_map():
	return get_tree().get_nodes_in_group("map")[-1]
