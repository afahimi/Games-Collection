extends Area2D


const VELOCITY = 700
const HEIGHT = 648

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if position.y > HEIGHT / 2:
		self.queue_free()
			
	position.y += VELOCITY * delta


func _on_area_entered(area: Area2D) -> void:
	if area.get_name() == "PlayerBullet":
		self.queue_free()
		
