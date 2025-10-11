class_name Stone extends Tile

static var icon : Texture = preload("res://assets/stone.png")
static var tileIndex : int = 0

func _init():
	type = "Stone"
	maxDur = 3
	dur = 3
