extends Control

var hoveringSlot = Vector2i(-1,-1)

func attach(node):
	if node is InventoryUISlot:
		node.mouse_entered.connect(func():hoveringSlot = node.pos)
		node.mouse_exited.connect(func():hoveringSlot = Vector2i(-1,-1))
	else:
		for i in node.get_children():
			attach(i)

func _ready():
	attach(self)
	for row in range(4):
		for col in range(9):
			var slot = $Panel/VBoxContainer.get_node(str(row)+"/"+str(col))
			slot.pos = Vector2i(row,col)

func updateSlots(inv, hbslot):
	
	for row in range(len(inv)):
	
		for col in range(len(inv[0])):
			
			var slot = $Panel/VBoxContainer.get_node(str(row)+"/"+str(col))
			if inv[row][col] == null:
				slot.clear()
			else:
				var cell = inv[row][col]
				
				slot.setCount(cell.count) 
				slot.setItem(cell.item.icon)
			
			if row==0 and col==hbslot:
				slot.setHighlight(true)
			else:
				slot.setHighlight(false)

func hoveringInventory():
	return Rect2($Panel.position, $Panel.size).has_point(get_local_mouse_position()) or \
		($Panel/Panel2.visible and Rect2($Panel/Panel2.global_position, $Panel/Panel2.size).has_point(get_local_mouse_position()))

func toggleInventory():
	$Panel/Panel2.visible = not $Panel/Panel2.visible
	for i in $Panel/VBoxContainer.get_children():
		if i.name=="0":continue
		i.visible = not i.visible
