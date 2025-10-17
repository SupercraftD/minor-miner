class_name Gel extends Item

static var icon = preload("res://assets/gel.png")
static var tooltip = "Material\n\"Doesn't look too flammable\""

func _init():
	consumable = false
	type = "Gel"

func use(mouseLoc : Vector2, player : Player, world : World):
	return 0
