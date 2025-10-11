extends Sprite2D

@export var left = false

func play(item, length):
	visible = true
	texture = item.icon
	$AnimationPlayer.speed_scale = 1.0 / length
	$AnimationPlayer.play("use" if !left else "useLEFT")
	await $AnimationPlayer.animation_finished
	visible = false
	
