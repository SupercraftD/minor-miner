class_name BasicShovel extends AbstractShovel

static var icon = load("res://assets/spoon.png")

func _init():
	super()
	strength = 1
	speed = 0.5
	reach = 200
	type="BasicShovel"
