class_name Player extends CharacterBody2D


var SPEED = 300.0
var JUMP_VELOCITY = -125.0
var maxJump = 600.0
var appliedJump = 0.0

var inventory = []
var hotbarslot = 0

func _ready():
	
	#init inv (temp)
	for row in range(4):
		inventory.append([])
		for col in range(9):
			inventory[-1].append(null)
	inventory[0][0] = {
		"item":BasicShovel.new(),
		"count":1
	}
	
	$CanvasLayer/Inventory.updateSlots(inventory, hotbarslot)

func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		appliedJump += JUMP_VELOCITY

	if (!Input.is_action_pressed("jump") or abs(appliedJump)>maxJump) and appliedJump!=0 and is_on_floor():
		velocity.y = appliedJump
		appliedJump = 0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	$Minor.flip_h = velocity.x < 0 if velocity.x!=0 else $Minor.flip_h
	
	move_and_slide()

var usageDb = false

func useItem():
	if Input.is_action_pressed("Use") and not usageDb and not $CanvasLayer/Inventory.hoveringInventory():
		usageDb = true
		
		if inventory[0][hotbarslot] != null:
			var db = inventory[0][hotbarslot].item.use(get_global_mouse_position(), self, get_parent())
			
			if (db != 0):
				useItemAnimation(db, inventory[0][hotbarslot].item)

			if inventory[0][hotbarslot].item.consumable and db!=0:
				inventory[0][hotbarslot].count -= 1
				
				if inventory[0][hotbarslot].count <= 0:
					inventory[0][hotbarslot] = null
				$CanvasLayer/Inventory.updateSlots(inventory, hotbarslot)
			
			
			await get_tree().create_timer(db).timeout
		usageDb = false

func useItemAnimation(db, item):
	var a = $ItemAnimRight
	if $Minor.flip_h:
		a = $ItemAnimLeft
	
	await a.play(item, db*0.75)

func handleInventory():
	
	#HOTBAR
	for i in range(1,10):
		if Input.is_action_just_pressed(str(i)):
			hotbarslot = i-1
			$CanvasLayer/Inventory.updateSlots(inventory, hotbarslot)
	
	if Input.is_action_just_pressed("scrolldown"):
		hotbarslot = (hotbarslot + 1)%10
		$CanvasLayer/Inventory.updateSlots(inventory, hotbarslot)
	elif Input.is_action_just_pressed("scrollup"):
		hotbarslot-=1
		if hotbarslot <0:
			hotbarslot = 8
		$CanvasLayer/Inventory.updateSlots(inventory, hotbarslot)
	
	#INVENTORY
	if Input.is_action_just_pressed("Inventory"):
		$CanvasLayer/Inventory.toggleInventory()
		$CanvasLayer/Inventory.updateSlots(inventory, hotbarslot)
	
	

func _physics_process(delta):
	movement(delta)
	handleInventory()
	useItem()

func addItem(type, tileItem):
	var firstEmpty = Vector2i(-1,-1)
	var added = false
	
	for row in range(len(inventory)):
		for col in range(len(inventory[row])):
			if inventory[row][col] == null:
				if firstEmpty == Vector2i(-1,-1):
					firstEmpty = Vector2i(row,col)
			else:
				if inventory[row][col].item.type == type:
					added = true
					inventory[row][col].count+=1
					break
	
	if not added:
		var r = firstEmpty.x
		var c = firstEmpty.y
		
		var item : Item
		if tileItem:
			item = TileItem.new(type)
		else:
			item = GlobalData.typeToItem[type].new()
		
		inventory[r][c] = {
			"item":item,
			"count":1
		}
	
	$CanvasLayer/Inventory.updateSlots(inventory, hotbarslot)
