extends Node2D

var TYPE = null

export(float) var DAMAGE = 1
export(int) var maxamount = 1
export(String) var animname = ""

func _ready():
	TYPE = get_parent().TYPE
	$anim.connect("animation_finished", self, "destroy")
	$anim.play(str(animname, get_parent().spritedir))
	var methodname = str("state_", animname)
	if get_parent().has_method(methodname):
		get_parent().state = animname

func destroy(animation):
	queue_free()
	
	var methodname = str("state_", animname)
	if get_parent().has_method(methodname):
		get_parent().state = "default"