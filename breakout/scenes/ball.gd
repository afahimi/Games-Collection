extends CharacterBody2D
const BASE_VELOCITY = 500
var VELOCITY = 500
const MAX_VELOCITY = 900
const PADDLE_HALF_WIDTH = 76
const BRICK_HALF_HEIGHT = 18
var hit_cooldown = 0.0  # Add cooldown variable

func _ready() -> void:
	position = Vector2(0,100)
	velocity = Vector2(0,1) * VELOCITY    

func _physics_process(delta: float) -> void:
	# Update cooldown timer
	if hit_cooldown > 0:
		hit_cooldown -= delta
	
	# Get camera reference (assuming it's a sibling)
	var camera = get_parent().get_node("Camera2D")
	if camera:
		# Get viewport size
		var viewport_size = get_viewport_rect().size
		
		# Calculate boundaries
		var half_height = viewport_size.y / 2
		var half_width = viewport_size.x / 2
	
		var next_x = position.x + velocity.x * delta
		var next_y = position.y + velocity.y * delta
		
		if next_x < -half_width or next_x > half_width:
			velocity = Vector2(-velocity.x, velocity.y)
		elif next_y < -half_height:
			velocity = Vector2(velocity.x, -velocity.y)
		elif next_y > half_height:
			# Bro Lost
			var score = int(get_parent().get_node("Control/Score").text.split(" ")[1])
			var high_score = int(get_parent().get_node("Control/High Score").text.split(" ")[2])
						
			get_parent().get_node("Control/High Score").text = "HIGH SCORE: " + str(max(score, high_score))
			get_parent().get_node("Control/Score").text = "SCORE: 0"
			
			
			get_parent().save_to_file(max(score, high_score))
			
			position = Vector2(0,20)
			velocity = Vector2(0,1) * BASE_VELOCITY
			VELOCITY = BASE_VELOCITY
			get_parent().reset_bricks()

		
		move_and_slide()
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	# Skip collision handling during cooldown
	if hit_cooldown > 0:
		return
		
	if area.get_parent().name == "Player":
		# Get reference to the paddle (assuming the area is the paddle)
		var paddle = get_parent().get_node("Player")
		var hit_position = clamp(global_position.x - paddle.global_position.x, -PADDLE_HALF_WIDTH, PADDLE_HALF_WIDTH)
		
		var hit_percent = hit_position / PADDLE_HALF_WIDTH
		
		var angle_degrees = 90 - (hit_percent * 45)
		var angle_rad = deg_to_rad(angle_degrees)
		
		# Set velocity based on this angle		
		VELOCITY = min(VELOCITY * 1.02, MAX_VELOCITY)
		
		velocity.x = cos(angle_rad) * VELOCITY
		velocity.y = -sin(angle_rad) * VELOCITY
	else:
		# This is a brick
		
		var brick_pos = area.position
		var ball_pos = position
		
		var bottom_y = brick_pos.y - BRICK_HALF_HEIGHT
		var top_y = brick_pos.y + BRICK_HALF_HEIGHT
		
		if ball_pos.y >= bottom_y and ball_pos.y <= top_y:
			velocity = Vector2(-velocity.x, velocity.y) 
		else:
			velocity = Vector2(velocity.x, -velocity.y)
		
		if velocity.length() > MAX_VELOCITY:
			velocity = velocity.normalized() * MAX_VELOCITY
		area.queue_free()
		
		# Set a short cooldown to prevent multiple hits
		hit_cooldown = 0.025
		
		get_parent().on_brick_destroyed()
