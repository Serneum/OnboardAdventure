extends "res://engine/entity.gd"

var movetimer_length = 15
var movetimer = 0

func _ready():
	add_to_group("enemies")
	$anim.play("default")
	movedir = dir.rand()

func _physics_process(delta):
	movement_loop()
	damage_loop()
	if movetimer > 0:
		movetimer -= 1
	elif movetimer == 0 || is_on_wall():
		movedir = dir.rand()
		movetimer = movetimer_length