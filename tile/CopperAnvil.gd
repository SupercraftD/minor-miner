class_name CopperAnvil extends Tile

static var icon : Texture = preload("res://assets/copperanvil.png")
static var tileIndex : int = 4
static var tooltip = "Placeable\n\"yes, it does look like an anvil\""

func _init():
	type = "Copper Anvil"
	maxDur = 5
	dur = 5
