extends "res://engine/item.gd"

func _ready():
	TYPE = get_parent().TYPE
	$anim.connect("animation_finished", self, "destroy")
	$anim.play(str("swing", get_parent().spritedir))
	
	sfx.play(load(str("res://items/sword_swing",int(rand_range(1,5)),".wav")))
	
	if get_parent().has_method("state_swing"):
		get_parent().state = "state_swing"

func destroy(animation):
	queue_free()
	
	if get_parent().has_method("state_swing"):
		get_parent().state = "default"