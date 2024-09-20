extends TouchScreenButton

onready var button_normal_texture = load("res://assets/buttons/button_up.png")
onready var button_pressed_texture = load("res://assets/buttons/button_up_pressed.png")

onready var button_pad = get_tree().get_nodes_in_group("arrow_button_pad")[-1]
onready var button_up = button_pad.get_node("ButtonUp")
onready var button_left = button_pad.get_node("ButtonLeft")

func _process(_delta):
	if is_pressed():
		Input.action_press("move_up")
		Input.action_press("move_left")

func _on_ButtonUpRightInvisible_pressed():
	button_up.set_deferred("normal", button_pressed_texture)
	button_left.set_deferred("normal", button_pressed_texture)

func _on_ButtonUpRightInvisible_released():
	Input.action_release("move_up")
	Input.action_release("move_left")
	button_up.set_deferred("normal", button_normal_texture)
	button_left.set_deferred("normal", button_normal_texture)
