class_name Air extends Tile

static var icon : Texture = null
static var tileIndex : int = -1

func _init():
	type = "Air"
	maxDur = -1
	dur = -1
