extends Control

func updateSlots(inv, hbslot):
	#for row in range(len(inv)):
	
	var row =0
	for col in range(len(inv[0])):
		
		var slot = $Panel.get_node(str(row)+"/"+str(col))
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
