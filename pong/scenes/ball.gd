extends CharacterBody2D

const VELOCITY = 500
var bonk_sound
var goal_sound

func _ready() -> void:
	bonk_sound = get_parent().get_node("Sounds/Bonk")
	goal_sound = get_parent().get_node("Sounds/Goal")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var x_options = [-1, 1]
	var x_selected = x_options[rng.randi() % x_options.size()]
	
	var y_selected = sin(rng.randf_range(PI/16 , PI/8))
	
	var y_sign_options = [-1, 1]
	var y_sign_selected = y_sign_options[rng.randi() % y_sign_options.size()]
	
	y_selected = y_selected * y_sign_selected
	
	x_selected = sqrt(1-y_selected**2) * x_selected
	
	velocity = Vector2(x_selected,y_selected) * VELOCITY	
		
	

func _physics_process(delta: float) -> void:
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
		
		if next_x < -half_width:
			get_parent().add_score_p2()
			position = Vector2(0,0)
			_ready()
			goal_sound.play()
			return
		elif next_x > half_width:
			get_parent().add_score_p1()
			position = Vector2(0,0)
			_ready()
			goal_sound.play()
			return
		elif next_y < -half_height or next_y > half_height:
			velocity = Vector2(velocity.x, -velocity.y)
			bonk_sound.play()
		
		move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	velocity *= 1.05
	if velocity.length() > 1000:
		velocity = velocity.normalized() * 1000
	velocity = Vector2(-velocity.x, velocity.y)
	bonk_sound.play()
