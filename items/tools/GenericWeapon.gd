class_name GenericWeapon extends AbstractWeapon

var proj
#static var icon

func _init():
	super()

func spawnProjectile(player) -> Projectile:
	var p = proj.instantiate()
	p.dmg = dmg
	p.reach = reach
	p.speed = projectileSpeed
	p.piercing = piercing
	p.shooter = player
	p.kb = kb
	
	return p
