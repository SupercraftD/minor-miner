class_name Coal extends Tile

static var icon : Texture = preload("res://assets/coal.png")
static var tileIndex : int = 1
static var tooltip = "Placeable\nMaterial"

func _init():
	type = "Coal"
	maxDur = 5
	dur = 5
