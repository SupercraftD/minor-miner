class_name InventoryUISlot extends Control

@export var transparentbg = false
var type : String = ""

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
	type = ""
	$Sprite2D.texture = null

func setHighlight(hl):
	$Panel2.visible = hl

func _process(delta):
	if Rect2(global_position, size).has_point(get_viewport().get_mouse_position()) and type != "":
		$nametooltip.visible = true
		$nametooltip.text = type
		$nametooltip.global_position = get_global_mouse_position() + Vector2(15,0)
	else:
		$nametooltip.visible = false
