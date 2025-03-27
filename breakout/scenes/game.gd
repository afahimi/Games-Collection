extends Node2D

var BRICK = preload("res://scenes/brick.tscn")
const BRICK_WIDTH = 38
const BRICK_HEIGHT = 25
const BRICK_PADDING = 5 
const DIM = [12, 5]
const START = [-540, -250]
const COLOURS = [
	"#E53935",  # Red
	"#F57F17",  # Orange
	"#FFD600",  # Yellow
	"#43A047",  # Green
	"#1E88E5",  # Blue
	"#8E24AA"   # Purple
]
var brick_count

var save_path = "user://variable.save"

func _ready() -> void:
	reset_bricks()
	
func reset_bricks() -> void:
	# Clear any existing bricks first
	for child in get_children():
		if child is Node2D and child.is_in_group("bricks"):
			child.queue_free()
	
	brick_count = DIM[0] * DIM[1]
	
	for i in range(1, DIM[0] + 1):
		for j in range(1, DIM[1] + 1):
			var curr_x = START[0] + i * (BRICK_WIDTH + BRICK_PADDING + 40)
			var curr_y = START[1] + j * (BRICK_HEIGHT + BRICK_PADDING + 25)
			
			# Make sure j-1 is within the array bounds
			var color_index = (j-1) % COLOURS.size()
			instantiate_block(curr_x, curr_y, COLOURS[color_index])

func instantiate_block(x: int, y: int, colour: String):
	var brick = BRICK.instantiate()
	brick.position = Vector2(x, y)
	
	# Set the color modulation
	brick.get_node("Sprite2D").modulate = Color.html(colour)
	
	# Add to the "bricks" group for easier management
	brick.add_to_group("bricks")
	
	add_child(brick)

func on_brick_destroyed() -> void:
	brick_count -= 1
	
	var score_txt = get_node("Control/Score").text.split(" ")
	get_node("Control/Score").text = "SCORE: " + str(int(score_txt[1]) + 10)
		
	if brick_count <= 0:
		print("All bricks destroyed! Starting new level...")
		reset_bricks()  # Use the new reset_bricks function

func save_to_file(data: int):
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_64(data)

func load_from_file():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var content = file.get_64()
	return content
