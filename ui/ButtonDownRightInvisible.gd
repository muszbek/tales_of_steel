extends TouchScreenButton

onready var button_normal_texture = load("res://assets/buttons/button_up.png")
onready var button_pressed_texture = load("res://assets/buttons/button_up_pressed.png")

onready var button_pad = get_tree().get_nodes_in_group("arrow_button_pad")[-1]
onready var button_down = button_pad.get_node("ButtonDown")
onready var button_right = button_pad.get_node("ButtonRight")

func _process(_delta):
	if is_pressed():
		Input.action_press("move_down")
		Input.action_press("move_right")

func _on_ButtonUpRightInvisible_pressed():
	button_down.set_deferred("normal", button_pressed_texture)
	button_right.set_deferred("normal", button_pressed_texture)

func _on_ButtonUpRightInvisible_released():
	Input.action_release("move_down")
	Input.action_release("move_right")
	button_down.set_deferred("normal", button_normal_texture)
	button_right.set_deferred("normal", button_normal_texture)
