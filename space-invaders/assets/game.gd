extends Node2D

const DIMENSIONS = [11, 5]
const INITIAL_POSITION = Vector2(-350, -222)
const SPACING = 70
const ENEMY = preload("res://assets/enemy.tscn")
var lives

func _ready() -> void:
	lives = 3
	
	# Yellow (1 row)
	for i in range(DIMENSIONS[0]):
		var curr_enemy = ENEMY.instantiate()
		curr_enemy.enemy_type = "yellow"
		curr_enemy.position = INITIAL_POSITION + Vector2(i * SPACING, 0)
		get_node("EnemyContainer").add_child(curr_enemy)

	# Green (2 rows)
	for row in range(2):
		for i in range(DIMENSIONS[0]):
			var curr_enemy = ENEMY.instantiate()
			curr_enemy.enemy_type = "green"
			var y_offset = SPACING * (row + 1)  # rows start at 1 to be below yellow
			curr_enemy.position = INITIAL_POSITION + Vector2(i * SPACING, y_offset)
			get_node("EnemyContainer").add_child(curr_enemy)

	# Blue (2 rows)
	for row in range(1):
		for i in range(DIMENSIONS[0]):
			var curr_enemy = ENEMY.instantiate()
			curr_enemy.enemy_type = "blue"
			var y_offset = SPACING * (row + 3)  # rows start at 3 to be below green
			curr_enemy.position = INITIAL_POSITION + Vector2(i * SPACING, y_offset)
			get_node("EnemyContainer").add_child(curr_enemy)

func decrement_lives() -> void:
	lives = max(0, lives - 1)
	get_node("Control/LivesContainer").update_lives()
	
	if lives == 0:
		get_node("Control/GameOverScreen").visible = true
		get_tree().paused = true


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
