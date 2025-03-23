extends "res://core/player/PlayerPrimitives.gd"

signal death_anim_finished

func _ready():
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		emit_signal("death_anim_finished")
