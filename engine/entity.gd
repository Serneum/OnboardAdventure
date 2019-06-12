extends KinematicBody2D

export var TYPE = "ENEMY"
export(int) var SPEED = 0
export(int) var DAMAGE = 1

var movedir = dir.center
var knockdir = dir.center
var spritedir = "down"

var hitstun = 0
var health = 1

func movement_loop():
	var motion
	if hitstun == 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * SPEED * 1.5
	move_and_slide(motion, dir.center)

func spritedir_loop():
	match movedir:
		dir.left:
			spritedir = "left"
		dir.right:
			spritedir = "right"
		dir.up:
			spritedir = "up"
		dir.down:
			spritedir = "down"

func anim_switch(animation):
	var newanim = str(animation, spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)

func damage_loop():
	if hitstun > 0:
		hitstun -= 1
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			health -= body.get("DAMAGE")
			hitstun = 10
			knockdir = global_transform.origin - body.global_transform.origin

func use_item(item):
	var newitem = item.instance()
	var groupname = str(item, self)
	newitem.add_to_group(groupname)
	add_child(newitem)
	if get_tree().get_nodes_in_group(groupname).size() > newitem.maxamount:
		newitem.queue_free()