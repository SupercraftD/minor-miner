class_name World extends Node2D

@onready var tilemap : TileMapLayer = $TileMapLayer

var worldData = {}

func _ready():
	var start = Vector2(5, 5) # start point
	var end = Vector2(100, 100) # end point
	
	tilemap.map_width = end.x-start.x + 50
	tilemap.map_height = end.y-start.y + 50
	
	var spawnpos = tilemap.generate_level(start, end, worldData)
	tilemap.generate_ores(worldData)
	
	$Player.position = spawnpos
	#print(worldData)

##returns type Tile of new tile created
func setTile(pos, type):
	
	var newCell : Tile = GlobalData.typeToTile[type].new()
	worldData[pos] = newCell
	tilemap.set_cell(pos, newCell.tileIndex ,Vector2i(0,0))
	
	return newCell
