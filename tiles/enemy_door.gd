extends StaticBody2D

onready var camera = get_node("../camera")
onready var player = get_node("../player")

var current_room = false

func _ready():
	$anim.play("open")
	add_to_group("enemy_door")

func _process(delta):
	if current_room:
		if camera.enemy_count == 0:
			if $anim.assigned_animation != "open":
				sfx.play(load(str("res://tiles/secret.wav")))
				$anim.play("open")
		elif !$area.get_overlapping_bodies().has(player):
			if $anim.assigned_animation != "close":
				sfx.play(load(str("res://tiles/door_shut.wav")))
				$anim.play("close")
	else:
		if $anim.assigned_animation != "open":
			$anim.play("open")