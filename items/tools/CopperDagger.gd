class_name CopperDagger extends GenericWeapon

static var icon = preload("res://assets/copperdagger.png")
static var tooltip = "Melee"+\
					"\nDamage: 10"+\
					"\nRange: 100"+\
					"\nUse Speed: 0.5"+\
					"\nProjectile Speed: 15"+\
					"\nKnockback: 250"

func _init():
	super()
	proj = preload("res://projectiles/copper_dagger_projectile.tscn")
	type="Copper Dagger"
	
	consumable = false
	piercing = true
	dmg = 10
	reach = 100
	speed = 0.5
	projectileSpeed = 15
	kb = 250
