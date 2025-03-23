extends ParallaxBackground

onready var layer2_still = $ParallaxLayer2/Sprite
onready var layer2_vib = $ParallaxLayer2/AnimatedSprite

onready var layer1_still = $ParallaxLayer1/Sprite
onready var layer1_vib = $ParallaxLayer1/AnimatedSprite

func _ready():
	pass # Replace with function body.

func start_vibration(layer):
	match layer:
		2:
			layer2_vib.set_deferred("visible", true)
			layer2_still.set_deferred("visible", false)
		1:
			layer1_vib.set_deferred("visible", true)
			layer1_still.set_deferred("visible", false)
