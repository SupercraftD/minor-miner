extends Control

func setCount(count):
	$Label.text = str(count)

func setItem(tex):
	$Sprite2D.texture = tex

func clear():
	$Label.text = ""
	$Sprite2D.texture = null

func setHighlight(hl):
	$Panel2.visible = hl
