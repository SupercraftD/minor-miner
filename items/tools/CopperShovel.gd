class_name CopperShovel extends AbstractShovel

static var icon = load("res://assets/coppershovel.png")
static var tooltip = "Strength: 2"+\
					"\nSpeed: 0.5"+\
					"\nReach: 200"
func _init():
	super()
	strength = 2
	speed = 0.5
	reach = 200
	type="Copper Shovel"
