extends Camera2D

const SCREEN_SIZE = Vector2(160, 128)
const HUD_THICKNESS = 16

var enemy_count = 0

func _process(delta):
	global_position = get_node("../player").global_position