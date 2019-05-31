extends KinematicBody2D

const SPEED = 70

var movedir = Vector2.ZERO
var spritedir = "down"
var validMoves = [
	{dir = "up", vec = Vector2(0, -1)},
	{dir = "down", vec = Vector2(0, 1)},
	{dir = "left", vec = Vector2(-1, 0)},
	{dir = "right", vec = Vector2(1, 0)}
]

func _physics_process(delta):
	controls_loop()
	movement_loop()
	spritedir_loop()
	
	if movedir != Vector2.ZERO:
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

func movement_loop():
	var motion = movedir.normalized() * SPEED
	move_and_slide(motion, Vector2.ZERO)

func spritedir_loop():
	match movedir:
		Vector2(-1, 0):
			spritedir = "left"
		Vector2(1, 0):
			spritedir = "right"
		Vector2(0, -1):
			spritedir = "up"
		Vector2(0, 1):
			spritedir = "down"

func anim_switch(animation):
	var newanim = str(animation, spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)