class_name InventoryUISlot extends Control

@export var transparentbg = false

var pos = Vector2i(-1,-1)

func _ready():
	if transparentbg:
		$Panel.visible = false
		$Panel2.visible = false

func setCount(count):
	$Label.text = str(count)

func setItem(tex):
	$Sprite2D.texture = tex

func clear():
	$Label.text = ""
	$Sprite2D.texture = null

func setHighlight(hl):
	$Panel2.visible = hl
