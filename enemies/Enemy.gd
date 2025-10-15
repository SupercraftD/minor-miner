@abstract class_name Enemy extends CharacterBody2D

var maxhp : float
var hp : float

var type : String
var dropTable : Array

var dmg : int

var player : Player = null
var world : World = null

@export var hitbox : Area2D
@export var hpbar : ProgressBar

var maxiframes = 3
var iframes = 0

var kb : float

var appliedKb = Vector2()

func _ready():
	hp = maxhp
	if not world:
		world = get_parent()
	print(maxhp)

@abstract func behavior(delta)

func onDeath():
	for item in dropTable:
		var type = item.type
		var p = item.probability
		var ti = item.tileItem
		
		if randf_range(0,100) <= p:
			DroppedItem.new(type, world, global_position, ti)
	queue_free()

func hit(dmg : float, kb : Vector2):
	if iframes <= 0:
		hp -= dmg
		appliedKb += kb
		
		if hp <= 0:
			onDeath()
		iframes = maxiframes

func detectPlayer():
	if not player:
		for i in hitbox.get_overlapping_bodies():
			if i is Player:
				player = i
				return

func handleHpBar():
	hpbar.max_value = maxhp
	hpbar.value = hp
	
	hpbar.visible = hp < maxhp

func _physics_process(delta):
	iframes-=1
	appliedKb = appliedKb.move_toward(Vector2(), 50)
	
	detectPlayer()
	behavior(delta)
	handleHpBar()
