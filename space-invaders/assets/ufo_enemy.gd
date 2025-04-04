extends CharacterBody2D


const SPEED = 5
const WIDTH = 1152

func _physics_process(delta: float) -> void:
	position.x += SPEED
	if position.x > WIDTH / 2:
		self.queue_free()
	
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_name() == "PlayerBullet":
		get_parent()._increment_score ([50, 100, 150, 300].pick_random())
		self.queue_free()
