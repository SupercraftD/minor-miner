@abstract class_name AbstractWeapon extends Item

var piercing = false

var dmg = 10
var reach = 10
var speed = 0.25

var projectileSpeed = 200

func _init():
	type="Weapon"
	consumable = false

func use(mouseLoc : Vector2, player : Player, world : World):
	var spawn = player.getHand(false)
	if mouseLoc.x < player.global_position.x:
		spawn = player.getHand(true)
	
	var angle = (mouseLoc-spawn.global_position).angle()
	var proj = spawnProjectile(player)
	
	
	proj.global_position = spawn.global_position
	proj.global_rotation = angle
	world.add_child(proj)
	
	return speed

@abstract func spawnProjectile(player) -> Projectile
