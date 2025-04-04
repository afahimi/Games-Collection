extends Area2D


const VELOCITY = 1000
const HEIGHT = 648

func _ready() -> void:
	self.modulate = Color(0.062, 0.808, 0.016)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if position.y < -HEIGHT / 2:
		self.queue_free()
			
	position.y -= VELOCITY * delta


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().get_name() != "Player":
		self.queue_free()
