extends "res://engine/entity.gd"

var state = "default"
var keys = 0

var validMoves = [
	{dir = "up", vec = dir.up},
	{dir = "down", vec = dir.down},
	{dir = "left", vec = dir.left},
	{dir = "right", vec = dir.right}
]

func _physics_process(delta):
	match state:
		"default":
			state_default()
		"swing":
			state_swing()
	keys = min(keys, 9)

func state_default():
	controls_loop()
	movement_loop()
	spritedir_loop()
	damage_loop()
	
	if movedir != dir.center:
		if is_on_wall():
			for i in validMoves:
				if spritedir == i.dir and test_move(transform, i.vec):
					anim_switch("push")
		else:
			anim_switch("walk")
	else:
		anim_switch("idle")
		
	if Input.is_action_just_pressed("a"):
		use_item(preload("res://items/sword.tscn"))

func state_swing():
	anim_switch("idle")
	movement_loop()
	damage_loop()
	movedir = dir.center

func controls_loop():
	var LEFT	= Input.is_action_pressed("ui_left")
	var RIGHT	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)