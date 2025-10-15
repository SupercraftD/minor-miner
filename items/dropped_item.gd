class_name DroppedItem extends CharacterBody2D

var type
var iScene : CharacterBody2D

func _init(pType, pWorld : Node2D, gPos, isTile):
	type = pType
	iScene = load("res://items/dropped_item.tscn").instantiate()
	iScene.global_position = gPos
	iScene.type = type
	iScene.isTile = isTile
	
	if isTile:
		iScene.get_node("Sprite2D").texture = GlobalData.typeToTile[type].icon
	else:
		iScene.get_node("Sprite2D").texture = GlobalData.typeToItem[type].icon
	pWorld.add_child(iScene)
