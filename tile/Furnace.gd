class_name Furnace extends Tile

static var icon : Texture = preload("res://assets/furnace.png")
static var tileIndex : int = 3
static var tooltip = "Placeable"

func _init():
	type = "Furnace"
	maxDur = 5
	dur = 5
