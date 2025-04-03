extends BoxContainer

#const PLAYER_TEXTURE = preload()

var game
var target_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = get_tree().get_root()
	target_sprite = 3


func update_lives() -> void:
	var curr_target = "Sprite2D" + str(target_sprite)
	get_node(curr_target).visible = false
	target_sprite = max(1, target_sprite - 1)
	
