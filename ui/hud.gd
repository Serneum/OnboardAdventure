extends CanvasLayer

onready var player = get_node("../player")

const MAX_HEARTS = 16
const HEART_ROW_SIZE = 8
const HEART_OFFSET = 8

func _ready():
	for i in min(player.MAXHEALTH, MAX_HEARTS):
		var new_heart = Sprite.new()
		new_heart.texture = $hearts.texture
		new_heart.hframes = $hearts.hframes
		$hearts.add_child(new_heart)

func _process(delta):
	for heart in $hearts.get_children():
		var index = heart.get_index()
		
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x, y)
		
		var last_heart = floor(player.health)
		if index > last_heart:
			heart.frame = 0
		elif index < last_heart:
			heart.frame = 4
		else:
			heart.frame = (player.health - last_heart) * 4
	
	$keys.frame = player.keys