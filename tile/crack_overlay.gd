class_name CrackOverlay extends Node2D

var iScene : Node2D

func _init(gPos : Vector2, world : World):
	iScene = load("res://tile/CrackOverlay.tscn").instantiate()
	iScene.global_position = gPos
	world.add_child(iScene)

##lvl : [1,3]
func setCrack(lvl):

	for s in iScene.get_children():
		s.visible = false
	iScene.get_node("Crack"+str(int(lvl))).visible = true

func destroy():
	iScene.queue_free()
	queue_free()
