class_name TileItem extends Item

var reach = 300
var speed = 0.25

var icon
var tooltip

func _init(pType):
	type = pType
	consumable = true
	icon = GlobalData.typeToTile[type].icon
	tooltip = GlobalData.typeToTile[type].tooltip

func use(mouseLoc : Vector2, player : Player, world : World):
	
	if player.global_position.distance_to(mouseLoc) > reach:
		return 0
	
	var pos = world.tilemap.local_to_map(mouseLoc)
	var cell : Tile = world.worldData[pos]
	
	if cell.type == "Air":
		world.setTile(pos, type)
	else:
		return 0
	
	return speed
	
