class_name BasicShovel extends AbstractShovel

static var icon = load("res://assets/spoon.png")
static var tooltip = "Strength: 1"+\
					"\nSpeed: 0.5"+\
					"\nReach: 200"+\
					"\n\"not a prison break but still works well\""

func _init():
	super()
	strength = 1
	speed = 0.5
	reach = 200
	type="Basic Shovel"
