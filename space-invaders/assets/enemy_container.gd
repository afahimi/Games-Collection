extends Node2D

const SPEED = 100
const DIMENSIONS = [1152, 648]
const JUMP = 20

var direction = -1

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta * direction
	
	var half_width = (get_parent().DIMENSIONS[0] * get_parent().SPACING) / 2
	
	if position.x - half_width < -DIMENSIONS[0] / 2:
		position.y += JUMP
		direction = 1
	elif position.x + half_width > DIMENSIONS[0] / 2:
		position.y += JUMP
		direction = -1
	
	
