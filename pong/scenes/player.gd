extends CharacterBody2D

const SPEED = 300.0

@export var player_color: Color = Color.WHITE
@export var up_key: String = "ui_up"
@export var down_key: String = "ui_down"

var play_mode = 1

var reaction_delay = 0.2
var reaction_timer = 0.0
var accuracy = 0.75
var max_cpu_speed = 300.0  # Slower than player

func _ready() -> void:
	$Sprite2D.modulate = player_color	

func _physics_process(delta: float) -> void:
	if play_mode:
		_player_process_control()
	else:
		# CPU AI with beatable logic
		reaction_timer += delta
		
		if reaction_timer >= reaction_delay:
			reaction_timer = 0
			
			var ball = get_parent().get_node("ball")
			if ball:
				var ball_position = ball.position.y
				var curr_position = position.y
				var diff_position = ball_position - curr_position
				
				# Add randomness to make CPU miss occasionally
				if randf() <= accuracy:
					var direction = 0
					if diff_position <= -10:
						direction -= 1
					elif diff_position >= 10:
						direction += 1
					
					# Use slower speed for CPU
					velocity.y = direction * max_cpu_speed
				else:
					# Sometimes move in wrong direction
					var wrong_direction = 1 if diff_position < 0 else -1
					velocity.y = wrong_direction * max_cpu_speed
					
		move_and_slide()
		_clamp_position()
		
	
func _player_process_control():
	# Handle movement
	var direction = 0
	if Input.is_action_pressed(up_key):
		direction -= 1
	if Input.is_action_pressed(down_key):
		direction += 1
	
	velocity.y = direction * SPEED
	move_and_slide()
	
	_clamp_position()
	
	
func _clamp_position():
	# Get camera reference (assuming it's a sibling)
	var camera = get_parent().get_node("Camera2D")
	if camera:
		# Get viewport size
		var viewport_size = get_viewport_rect().size
		
		# Calculate boundaries
		var half_height = viewport_size.y / 2
		
		# Get character size (assuming it has a sprite)
		var char_height = 0
		if get_node("Sprite2D"):
			char_height = get_node("Sprite2D").texture.get_height() * get_node("Sprite2D").scale.y / 2
		
		# Calculate limits
		var top_limit = camera.position.y - half_height + char_height
		var bottom_limit = camera.position.y + half_height - char_height
		
		# Clamp position
		position.y = clamp(position.y, top_limit, bottom_limit)
