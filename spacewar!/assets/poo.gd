extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var viewport_size = get_viewport().size
var direction = Vector2(0, 1)

const ROTATION_SPEED = 5
const MOVEMENT_SPEED = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	rotation += ROTATION_SPEED * delta
	position += direction * MOVEMENT_SPEED
	if position.x > viewport_size.x / 2 or position.x < -viewport_size.x / 2:
		self.queue_free()
	elif position.y > viewport_size.y / 2 or position.y < -viewport_size.y / 2:
		self.queue_free()
