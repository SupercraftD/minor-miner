extends CharacterBody2D

var type
var isTile = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	for i in $Hitbox.get_overlapping_bodies():
		if i.is_in_group("Player"):
			i.addItem(type, isTile)
			queue_free()

	move_and_slide()
