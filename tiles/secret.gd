extends Node2D

onready var camera = get_node("../camera")

export(String) var item = "key"
export var TYPE = "ENEMY"

var current_room = false
var has_spawned = false

func _ready():
	add_to_group("secret")

func _process(delta):
	if current_room && !has_spawned && conditions_met():
		sfx.play(load(str("res://tiles/secret.wav")))
		var scene_path = str("res://pickups/", item, ".tscn")
		instance_scene(load(scene_path))
			
		has_spawned = true

func instance_scene(scene):
	var new_scene = scene.instance()
	new_scene.global_position = global_position
	get_parent().add_child(new_scene)

func conditions_met():
	match TYPE:
		"ENEMY":
			return camera.enemy_count == 0