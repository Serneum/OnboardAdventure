extends "res://engine/entity.gd"

var validMoves = [
	{dir = "up", vec = dir.up},
	{dir = "down", vec = dir.down},
	{dir = "left", vec = dir.left},
	{dir = "right", vec = dir.right}
]

func _physics_process(delta):
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

func controls_loop():
	var LEFT	= Input.is_action_pressed("ui_left")
	var RIGHT	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)