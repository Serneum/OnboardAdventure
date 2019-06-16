extends Area2D

onready var camera = get_node("../camera")
onready var player = get_node("../player")

var last_room_state = false
var room_state = false

func _process(delta):
	if camera == null:
		return
	
	print(overlaps_body(player))
	if overlaps_body(player):
		room_state = true
		camera.limit_left = global_position.x
		camera.limit_right = global_position.x + camera.SCREEN_SIZE.x * scale.x
		camera.limit_top = global_position.y
		camera.limit_bottom = global_position.y + camera.SCREEN_SIZE.y * scale.y
	else:
		room_state = false
	
	if room_state != last_room_state:
		for body in get_overlapping_bodies():
			if body.get("TYPE") == "ENEMY":
				body.set_physics_process(room_state)
		
		if !room_state:
			for area in get_overlapping_areas():
				if area.get("disappears") == true:
					area.queue_free()
	
	for door in get_tree().get_nodes_in_group("enemy_door"):
		door.current_room = room_state
	
	if room_state:
		get_enemies()
	
	last_room_state = room_state

func get_enemies():
	var enemies = []
	for body in get_overlapping_bodies():
		if body.get("TYPE") == "ENEMY" and enemies.find(body) == -1:
			enemies.append(body)
	camera.enemy_count = enemies.size()