class_name InventoryUISlot extends Control

@export var transparentbg = false
var type : String = ""
var tooltip : String

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

var hovering = false

func _process(_delta):
	
	var cv = get_parent()
	while not (cv is CanvasLayer):
		cv = cv.get_parent()
	
	var tt = cv.get_node("tooltip")
	
	if Rect2(global_position, size).has_point(get_viewport().get_mouse_position()) and type != "":
		tt.setText("[b]"+type+"[/b]"+"\n"+tooltip)
		if not hovering:
			tt.hc += 1
			hovering=true
	elif hovering:
		tt.hc-=1
		hovering=false
