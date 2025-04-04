extends CharacterBody2D

@export var enemy_type = "green"
var rng = RandomNumberGenerator.new()
var bullet = preload("res://assets/enemy_bullet.tscn")
var curr_range

func _ready() -> void:
	$AnimatedSprite2D.play(enemy_type)
	curr_range = init_random_interval()

func _process(delta: float) -> void:
	curr_range -= delta
	
	if curr_range <= 0:
		# fire a bullet
		var curr_bullet = bullet.instantiate()
		curr_bullet.name = "EnemyBullet"
		curr_bullet.position = global_position
		get_node("/root/Game").add_child(curr_bullet)
		curr_range = init_random_interval()

func init_random_interval():
	return rng.randi_range(1, 20)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_name() == "PlayerBullet":
		var game = self.get_node("../../")
		game._increment_score(_get_desired_score())
		
		area.queue_free()
		self.queue_free()

func _get_desired_score():
	if enemy_type == "blue":
		return 10
	elif enemy_type == "green":
		return 20
	else:
		return 30
		
