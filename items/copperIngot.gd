class_name CopperIngot extends Item

static var icon = preload("res://assets/copperingot.png")
static var tooltip = "Material"

func _init():
	consumable = false
	type = "Copper Ingot"

func use(mouseLoc : Vector2, player : Player, world : World):
	return 0
