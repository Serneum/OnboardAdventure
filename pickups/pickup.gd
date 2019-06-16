extends Area2D

export(bool) var disappears = false
export(String, FILE) var sound = "res://pickups/item.wav"

func _ready():
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

# TODO: Find a way to delegate this to child classes
func body_entered(body):
	match self.name:
		"key":
			if body.name == "player" && body.keys < 9:
				body.keys += 1
				destroy()
		"heart":
			if body.name == "player":
				body.health = min(body.health + 1, body.MAXHEALTH)
				destroy()