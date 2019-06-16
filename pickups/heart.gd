extends "res://pickups/pickup.gd"

func body_entered(body):
	if body.name == "player":
		body.health = min(body.health + 1, body.MAXHEALTH)
		destroy()