class_name Game
extends Node2D

const GAME_SCENE = preload("res://scenes/game.tscn")
const MENU_SCENE = preload("res://scenes/menu.tscn")
const SECOND_PLAYER = preload("res://scenes/player.tscn")

var pause_sound

var score_p1 = 0
var score_p2 = 0
var second_player_mode = 0  # Default mode

func _ready():
	add_child(_instantiate_second_player(second_player_mode))
	update_score_display()
	
	pause_sound = get_node("Sounds/Pause")
	
static func new_game(mode: int):
	var game = GAME_SCENE.instantiate()
	game.second_player_mode = mode
	return game
	
func _instantiate_second_player(play_mode: int):
	var player = SECOND_PLAYER.instantiate()
	player.player_color = Color.html("#e62029")
	player.position = Vector2(556, 0)
	player.up_key = "ui_up"
	player.down_key = "ui_down"
	player.play_mode = play_mode
	player.name = "P2"
	
	return player
	
func update_score_display():
	$Control/Label.text = str(score_p1)
	$Control/Label2.text = str(score_p2)

func add_score_p1():
	score_p1 += 1
	update_score_display()
	if score_p1 >= 10:
		_render_end_screen("P1")

func add_score_p2():
	score_p2 += 1
	update_score_display()
	if score_p2 >= 10:
		_render_end_screen("P2")


func _on_pause_pressed() -> void:
	
	get_tree().paused = true
	
	get_node("Control/PauseButton").visible = false
	
	var menu = get_node("Control/PauseMenu")
	menu.visible = true
	
	pause_sound.play()

func _on_continue_pressed() -> void:
	get_node("Control/PauseButton").visible = true
	
	get_node("Control/PauseMenu").visible = false
	
	get_tree().paused = false
	
	pause_sound.play()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_title_pressed() -> void:
	get_tree().paused = false
	get_tree().root.add_child(MENU_SCENE.instantiate())
	self.queue_free()
	
func _render_end_screen(winner: String) -> void:
	get_tree().paused = true
	var screen = get_node("Control/EndMenu")
	var label = screen.get_node("MarginContainer/VBoxContainer/Wins")
	label.text = winner + " " + label.text
	screen.visible = true

func _on_restart_pressed() -> void:
	get_node("Control/EndMenu").visible = false
	get_tree().paused = false
	var game = self.new_game(second_player_mode)
	get_tree().root.add_child(game)
	self.queue_free()
