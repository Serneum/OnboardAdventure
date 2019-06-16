extends Area2D

export(bool) var disappears = false
export(String, FILE) var sound = "res://pickups/item.wav"

func _ready():
	if disappears:
		add_to_group("disappears")
	connect("body_entered", self, "body_entered")
	connect("area_entered", self, "area_entered")

func destroy():
	if File.new().file_exists(sound):
		sfx.play(load(sound))
	queue_free()

func area_entered(area):
	var parent = area.get_parent()
	if parent.name == "sword":
		body_entered(parent.get_parent())

# Delegate to child implementations
func body_entered(body):
	return