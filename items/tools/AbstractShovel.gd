class_name AbstractShovel extends Item

var strength : int
var speed : float
var reach : float

func _init():
	type = "Shovel"
	consumable = false

##returns debounce time to next usage
func use(mouseLoc : Vector2, player : Player, world : World):
	if player.global_position.distance_to(mouseLoc) > reach:
		return 0
	
	var pos = world.tilemap.local_to_map(mouseLoc)
	var cell : Tile = world.worldData[pos]
	
	if cell.type == "Air":
		return 0
	
	cell.dur -= strength
	
	#CRACK OVERLAY LOGIC
	var crack : CrackOverlay
	
	if (!cell.mods.has("crack")):
		cell.mods.crack = CrackOverlay.new(world.tilemap.map_to_local(pos), world)
	crack = cell.mods.crack
	
	var lvl = 4 - (int((float(cell.dur if cell.dur>=0 else 0)/cell.maxDur)*3) + 1)
	crack.setCrack(lvl)
	
	#MINE BLOCK LOGIC
	if cell.dur<=0:
		if (cell.mods.has("crack")):
			cell.mods.crack.destroy()
		
		DroppedItem.new(cell.type, world, mouseLoc, true)
		world.setTile(pos, "Air")
	
	return speed
