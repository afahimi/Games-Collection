extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	_instantiate_game(1)


func _on_p_mode_pressed() -> void:
	_instantiate_game(0)
	

func _on_quit_pressed() -> void:
	get_tree().quit()
	
	
func _instantiate_game(mode: int) -> void:
	var game = Game.new_game(mode)
	get_tree().root.add_child(game)
	self.queue_free()
