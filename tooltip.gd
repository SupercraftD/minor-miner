extends Panel

var hc =0 

func _process(_delta):
	if hc==0:
		visible = false
	else:
		visible = true
	size.y = $RichTextLabel.size.y + 15
	global_position = get_global_mouse_position() + Vector2(15,0)
	if get_global_transform_with_canvas().origin.x > get_viewport().size.x/2:
		global_position = get_global_mouse_position() - Vector2(size.x,0)

func setText(text):
	$RichTextLabel.text = text
