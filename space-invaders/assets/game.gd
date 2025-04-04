extends Node2D

const DIMENSIONS = [11, 5]
const INITIAL_POSITION = Vector2(-350, -222)
const SPACING = 70
const ENEMY = preload("res://assets/enemy.tscn")
const UFO_ALIEN = preload("res://assets/ufo_enemy.tscn")
var rng = RandomNumberGenerator.new()
var lives
var alien_interval

func _ready() -> void:
	lives = 3
	alien_interval = _get_alien_interval()
	
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

func _process(delta: float) -> void:
	alien_interval -= delta
	
	if alien_interval <= 0:
		# Spawn Alien -600, -280
		var curr_alien = UFO_ALIEN.instantiate()
		curr_alien.position = Vector2(-600, -280)
		self.add_child(curr_alien)
		alien_interval = _get_alien_interval()

func decrement_lives() -> void:
	lives = max(0, lives - 1)
	get_node("Control/LivesContainer").update_lives()
	
	if lives == 0:
		get_node("Control/GameOverScreen").visible = true
		get_tree().paused = true

func _get_alien_interval():
	return rng.randi_range(10, 30)

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _increment_score(amount: int):
	var score = get_node("Control/Score")
	var curr_score = int(score.text.split(" ")[1])
	score.text = "SCORE: " + str(curr_score + amount)
