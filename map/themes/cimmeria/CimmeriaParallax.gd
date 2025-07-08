extends ParallaxBackground

onready var snow_back = $ParallaxLayer2/SnowEffectScreen

func _ready():
	pass # Replace with function body.

func start_snow():
	snow_back.set_deferred("visible", true)

func stop_snow():
	snow_back.set_deferred("visible", false)
