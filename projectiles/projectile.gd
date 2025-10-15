class_name Projectile extends Area2D

var shooter

var reach : float
var dmg : float
var kb : float
var speed : float

var piercing : bool

var dist = 0
func _physics_process(_delta):
	dist += Vector2(speed,0).rotated(global_rotation).length()
	position += Vector2(speed,0).rotated(global_rotation)
	
	
	if dist>=reach:
		queue_free()
	else:
		
		for i in get_overlapping_bodies():
			if i != shooter:
				#TODO ADD HIT LOGIC
				#TODO ADD PARTICLE LOGIC
				
				if i is Enemy:
					i.hit(dmg, global_position.direction_to(i.global_position)*kb)
				
				if not piercing or i is TileMapLayer:
					queue_free()
