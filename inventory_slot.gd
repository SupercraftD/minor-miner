class_name InventoryUISlot extends Control

var pos = Vector2i(-1,-1)

func setCount(count):
	$Label.text = str(count)

func setItem(tex):
	$Sprite2D.texture = tex

func clear():
	$Label.text = ""
	$Sprite2D.texture = null

func setHighlight(hl):
	$Panel2.visible = hl
