class_name Copper extends Tile

static var icon : Texture = preload("res://assets/copper.png")
static var tileIndex : int = 2
static var tooltip = "Placeable\nMaterial"

func _init():
	type = "Copper"
	maxDur = 5
	dur = 5
