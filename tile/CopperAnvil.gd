class_name CopperAnvil extends Tile

static var icon : Texture = preload("res://assets/copperanvil.png")
static var tileIndex : int = 4

func _init():
	type = "Copper Anvil"
	maxDur = 5
	dur = 5
