extends Area2D

onready var camera = get_node("../camera")
onready var player = get_node("../player")

var last_room_state = false
var room_state = false

var room_rect = Rect2()

func _ready():
	room_rect = Rect2(global_position, camera.SCREEN_SIZE * scale)

func _process(delta):
	if camera == null:
		return
	
	if overlaps_body(player):
		room_state = true
		camera.limit_left = room_rect.position.x
		camera.limit_right = room_rect.end.x
		camera.limit_top = room_rect.position.y - 16
		camera.limit_bottom = room_rect.end.y
	else:
		room_state = false
	
	if room_state != last_room_state:
		for body in get_overlapping_bodies():
			if body.get("TYPE") == "ENEMY":
				body.set_physics_process(room_state)
		
		if !room_state:
			for area in get_overlapping_areas():
				var body = area.get_parent()
				if area.get_groups().has("disappears"):
					area.queue_free()
				if body.get_groups().has("projectile"):
					body.queue_free()
	
	for door in get_tree().get_nodes_in_group("enemy_door"):
		if room_rect.has_point(door.global_position):
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