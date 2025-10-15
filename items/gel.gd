class_name Gel extends Item

static var icon = preload("res://assets/gel.png")

func _init():
	consumable = false
	type = "Gel"

func use(mouseLoc : Vector2, player : Player, world : World):
	return 0
