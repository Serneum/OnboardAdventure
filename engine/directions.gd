extends Node

const center = Vector2.ZERO
const left = Vector2(-1, 0)
const right = Vector2(1, 0)
const up = Vector2(0, -1)
const down = Vector2(0, 1)

const list = [left, right, up, down]

func rand():
	match(randi() % 4):
		0:
			return left
		1:
			return right
		2:
			return up
		3:
			return down