extends Control

func _ready():
	$Panel/Label2/InventorySlot.clear()

func toggleCrafting():
	$Panel.visible = not $Panel.visible
	if $Panel.visible:
		refreshMenu()

func _on_button_pressed():
	toggleCrafting()

var invSlot = preload("res://inventory_slot.tscn")
var shownRecipes = []
var selectedRecipe = ""

func refreshMenu():
	
	for s in $Panel/Grid/GridContainer.get_children():
		$Panel/Grid/GridContainer.remove_child(s)
		s.queue_free()
	shownRecipes = []
	#$Panel/Button.disabled = true
	
	var availableToCraft = []
	
	for i in GlobalData.craftingRecipes:
		if $Panel/filter.text.to_lower() in i.to_lower() or $Panel/filter.text == "":
			
			if $Panel/CheckBox.button_pressed:
				availableToCraft.push_back(i)
			else:
				
				var craftable = canCraft(i)
					
				if craftable:
					availableToCraft.push_back(i)
	
	for item in availableToCraft:
		var slot : InventoryUISlot = invSlot.instantiate()
		$Panel/Grid/GridContainer.add_child(slot)
		shownRecipes.push_back(item)
		
		var tex 
		if GlobalData.craftingRecipes[item].tileItem:
			tex = GlobalData.typeToTile[item].icon
		else:
			tex = GlobalData.typeToItem[item].icon
		
		if GlobalData.craftingRecipes[item].count != 1:
			slot.setCount(GlobalData.craftingRecipes[item].count)
		
		slot.setItem(tex)
		slot.type = item
	
	if selectedRecipe not in availableToCraft:
		selectedRecipe = ""
		for n in $Panel/Requires/HBoxContainer.get_children():
			n.queue_free()
		$Panel/Label2/InventorySlot.clear()
		
	else:
		for i in range(len($Panel/Grid/GridContainer.get_children())):
			if $Panel/Grid/GridContainer.get_child(i).type == selectedRecipe:
				selectRecipe(i)

func wouldShow():
	var availableToCraft = []
	
	for i in GlobalData.craftingRecipes:
		if $Panel/filter.text.to_lower() in i.to_lower() or $Panel/filter.text == "":
			
			if $Panel/CheckBox.button_pressed:
				availableToCraft.push_back(i)
			else:
				
				var craftable = canCraft(i)
					
				if craftable:
					availableToCraft.push_back(i)
	
	return availableToCraft

func canCraft(i):
	var indexInv = {}
	var inv = get_parent().get_parent().inventory
	
	for row in range(len(inv)):
		for col in range(len(inv[0])):
			if inv[row][col]==null:continue
			var type = inv[row][col].item.type
			var cnt = inv[row][col].count
			
			if type in indexInv:
				indexInv[type] += cnt
			else:
				indexInv[type] = cnt
	
	# TODO: ADD STATION LOGIC
	var uncraftable = false
	for item in GlobalData.craftingRecipes[i].requires:
		if item.type in indexInv and indexInv[item.type] >= item.count:
			pass
		else:
			uncraftable=true
	
	var player : Player = get_parent().get_parent()
	var tm : TileMapLayer = player.get_parent().tilemap
	var worldDat = player.get_parent().worldData
	
	var pos = tm.local_to_map(player.global_position)
	
	#01234
	#01234
	#01X34
	#01234
	#01234
	
	var stationInRange = true
	if GlobalData.craftingRecipes[i].station != "":
		stationInRange = false
		for x in range(pos.x - player.stationRange, pos.x + player.stationRange + 1):
			for y in range(pos.y - player.stationRange, pos.y + player.stationRange + 1):
				var spot = Vector2i(x,y)
				if worldDat.has(spot):
					if worldDat[spot].type == GlobalData.craftingRecipes[i].station:
						stationInRange=true
						break
	
	return (not uncraftable) and stationInRange


func _on_check_box_pressed():
	refreshMenu()

func _on_filter_text_changed(new_text):
	refreshMenu()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if $Panel.visible:
				for i in range(len($Panel/Grid/GridContainer.get_children())):
					var slot = $Panel/Grid/GridContainer.get_child(i)
					if Rect2(slot.global_position, slot.size).has_point(get_viewport().get_mouse_position()):
						selectRecipe(i)

func selectRecipe(idx):
	for x in $Panel/Grid/GridContainer.get_children():
		x.setHighlight(false)
	$Panel/Grid/GridContainer.get_child(idx).setHighlight(true)
	selectedRecipe = shownRecipes[idx]
	
	for x in $Panel/Requires/HBoxContainer.get_children():
		x.queue_free()
	
	for item in GlobalData.craftingRecipes[selectedRecipe].requires:
		var slot = invSlot.instantiate()
		$Panel/Requires/HBoxContainer.add_child(slot)
		
		var tex 
		if item.tileItem:
			tex = GlobalData.typeToTile[item.type].icon
		else:
			tex = GlobalData.typeToItem[item.type].icon
		
		slot.setItem(tex)
		slot.type = item.type
		slot.setCount(item.count)
	
	if GlobalData.craftingRecipes[selectedRecipe].station != "":
		$Panel/Label2/InventorySlot.setItem(GlobalData.typeToTile[GlobalData.craftingRecipes[selectedRecipe].station].icon)
		$Panel/Label2/InventorySlot.type = GlobalData.craftingRecipes[selectedRecipe].station
	else:
		$Panel/Label2/InventorySlot.clear()

func _process(_delta):
	if shownRecipes.hash() != wouldShow().hash():
		refreshMenu()
	
	if selectedRecipe !="" and canCraft(selectedRecipe):
		$Panel/Button.disabled = false
	else:
		$Panel/Button.disabled = true

func _on_craft_pressed():
	var consumed = {}
	var shouldConsume = {}
	for i in GlobalData.craftingRecipes[selectedRecipe].requires:
		consumed[i.type] = 0
		shouldConsume[i.type] = i.count
	
	var inv = get_parent().get_parent().inventory
	
	for row in range(len(inv)):
		for col in range(len(inv[0])):
			if inv[row][col]==null:continue
			var type = inv[row][col].item.type
			var cnt = inv[row][col].count
			
			if type in shouldConsume:
				if consumed[type] < shouldConsume[type]:
					var added = cnt
					if consumed[type] + added > shouldConsume[type]:
						added = shouldConsume[type]-consumed[type]
					
					inv[row][col].count -= added
					consumed[type] += added
					
					if inv[row][col].count <= 0:
						inv[row][col] = null
	
	for x in range(GlobalData.craftingRecipes[selectedRecipe].count):
		get_parent().get_parent().addItem(selectedRecipe, GlobalData.craftingRecipes[selectedRecipe].tileItem)
	get_parent().get_parent().refreshInventory()
	
