class_name DebugWand extends Item

static var icon = preload("res://assets/crack3.png")

static var slime = preload("res://enemies/slime.tscn")

func _init():
	type = "Debug Wand"

func use(mouseLoc : Vector2, player : Player, world : World):
	var s = slime.instantiate()
	s.global_position = mouseLoc
	world.add_child(s)
	
	return 1
