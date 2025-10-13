class_name Projectile extends Area2D

var shooter

var reach : float
var dmg : float
var speed : float

var piercing : bool

var dist = 0
func _physics_process(delta):
	dist += Vector2(speed,0).rotated(global_rotation).length()
	position += Vector2(speed,0).rotated(global_rotation)
	
	
	if dist>=reach:
		queue_free()
	else:
		
		for i in get_overlapping_bodies():
			if i != shooter:
				#TODO ADD HIT LOGIC
				#TODO ADD PARTICLE LOGIC
				
				
				if not piercing or i is TileMapLayer:
					queue_free()
