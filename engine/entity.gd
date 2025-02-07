extends KinematicBody2D

export var TYPE = "ENEMY"
export(int) var SPEED = 0
export(float) var DAMAGE = 1
export(int) var MAXHEALTH = 2

var movedir = Vector2.ZERO
var last_movedir = Vector2(0, 1)
var knockdir = Vector2.ZERO
var spritedir = "down"

var hitstun = 0
var health = 0
var texture_default = null
var texture_hurt = null
var sound_damage = preload("res://enemies/enemy_hurt.wav")

func _ready():
	health = MAXHEALTH
	if TYPE == "ENEMY":
		set_collision_mask_bit(1,1)
		set_physics_process(false)
	texture_default = $Sprite.texture
	texture_hurt = load($Sprite.texture.get_path().replace(".png", "_hurt.png"))

func movement_loop():
	var motion
	if hitstun == 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * 125
	move_and_slide(motion, Vector2.ZERO)
	if movedir != dir.center && dir.list.has(movedir):
		last_movedir = movedir

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
	health = min(health, MAXHEALTH)

	if hitstun > 0:
		hitstun -= 1
		$Sprite.texture = texture_hurt
	else:
		$Sprite.texture = texture_default
		if TYPE == "ENEMY" && health <= 0:
			enemy_die()
	
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hitstun == 0 and does_damage(body) and body.get("TYPE") != TYPE:
			sfx.play(sound_damage)
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
		return
	newitem.start()

func does_damage(body):
	var damage = body.get("DAMAGE")
	return damage != null and damage > 0

func instance_scene(scene):
	var new_scene = scene.instance()
	new_scene.global_position = global_position
	get_parent().add_child(new_scene)

func enemy_die():
	instance_scene(preload("res://enemies/enemy_death.tscn"))
	var drop =  randi() % 3
	match drop:
		0:
			instance_scene(preload("res://pickups/heart.tscn"))
	queue_free()