class_name SlimeEnemy extends Enemy

func _ready():
	maxhp = 30
	type = "Slime"
	dmg = 10
	kb = 500
	dropTable = [
		{
			"type":"Gel",
			"probability":100,
			"tileItem":false
		},
		{
			"type":"Gel",
			"probability":50,
			"tileItem":false
		}
	]
	super()


var chargingJump = 0

var JUMP_VEL = 600.0
var H_VEL = 600.0

func behavior(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if player != null:
		if is_on_floor() and chargingJump <= 1:
			chargingJump += delta
			scale -= Vector2(.005,.005)
		elif chargingJump >= 1:
			chargingJump = 0
			scale = Vector2(1,1)
			
			velocity.y = -JUMP_VEL
			velocity.x = H_VEL if player.global_position.x > global_position.x else -H_VEL
	
	velocity.x = move_toward(velocity.x, 0, 10)
	
	velocity += appliedKb
	
	move_and_slide()
	
	for i in $hurtbox.get_overlapping_bodies():
		if i is Player:
			i.hit(dmg, global_position.direction_to(i.global_position)*kb)
