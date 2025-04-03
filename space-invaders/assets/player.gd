extends CharacterBody2D


const SPEED = 300.0
const GAME_WIDTH = 1152
const COOLDOWN_TIME = 3

var bullet = preload("res://assets/player_bullet.tscn")
var cooldown

func _ready() -> void:
	cooldown = COOLDOWN_TIME
	


func _physics_process(delta: float) -> void:
	cooldown = max(0, cooldown - delta)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	if Input.is_action_just_pressed("ui_space") and not get_parent().has_node("PlayerBullet"):
		var curr_bullet = bullet.instantiate()
		curr_bullet.name = "PlayerBullet"
		curr_bullet.position = global_position
		get_parent().add_child(curr_bullet)


	move_and_slide()
	
	position.x = clamp(position.x, -GAME_WIDTH / 2, GAME_WIDTH / 2)

	


func _on_player_area_entered(area: Area2D) -> void:
	if area.get_name() != "PlayerBullet" && cooldown == 0:
		get_parent().decrement_lives()
		cooldown = COOLDOWN_TIME
