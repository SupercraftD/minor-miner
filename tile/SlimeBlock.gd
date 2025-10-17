class_name SlimeBlock extends Tile

static var icon : Texture = preload("res://assets/slimetile.png")
static var tileIndex : int = 5

func _init():
	type = "Slime Block"
	maxDur = 1
	dur = 1
