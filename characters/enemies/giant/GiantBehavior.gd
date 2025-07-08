extends Node

enum states {IDLE, ATTACK, STRUCK, RECOVER, DEAD, REMOVED}

const ATTACK_DISTANCE = 64

onready var player = get_tree().get_nodes_in_group("player")[-1]
var giant

var state = states.IDLE

func _ready():
	yield(owner, "ready")
	giant = owner
	giant.behavior = self

func call_physics_process(_delta):
	match state:
		states.IDLE:
			giant.skin.idle_animate()
			maybe_attack()
		states.ATTACK:
			pass
		states.STRUCK:
			giant.skin.struck_animate()
			maybe_recover()
		states.RECOVER:
			pass
		states.DEAD:
			pass

func distance_from_player() -> float:
	return (player.global_position - (giant.global_position + giant.center)).length()

func maybe_attack():
	if $RecoverTimer.time_left > 0: return
	if distance_from_player() < ATTACK_DISTANCE: attack()

func maybe_recover():
	if $StruckTimer.time_left <= 0: recover()

func attack():
	state = states.ATTACK
	giant.skin.start_attack()
	giant.hammer.up()

func finish_attack():
	state = states.STRUCK
	$StruckTimer.start()
	giant.hammer.down()

func recover():
	state = states.RECOVER
	giant.skin.start_recover()
	giant.hammer.up()

func finish_recover():
	state = states.IDLE
	$RecoverTimer.start()
	giant.hammer.front()

func death():
	state = states.DEAD
	giant.disable_collisions()
	giant.skin.start_death_animate()
