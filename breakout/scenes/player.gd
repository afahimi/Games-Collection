extends CharacterBody2D

const SPEED = 900

@export var player_color: Color = Color.WHITE

func _ready() -> void:
	$Sprite2D.modulate = player_color

func _physics_process(delta: float) -> void:
	_player_process_control()
	
func _player_process_control():
	# Handle movement
	var direction = 0
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	
	velocity.x = direction * SPEED
	move_and_slide()
	
	_clamp_position()
	
	
func _clamp_position():
	# Get camera reference (assuming it's a sibling)
	var camera = get_parent().get_node("Camera2D")
	if camera:
		# Get viewport size
		var viewport_size = get_viewport_rect().size
		
		# Calculate boundaries
		var half_width = viewport_size.x / 2
		
		# Get character size (assuming it has a sprite)
		var char_width = 0
		if get_node("Sprite2D"):
			char_width = get_node("Sprite2D").texture.get_width() * get_node("Sprite2D").scale.x / 2
		
		# Calculate limits
		var left_limit = camera.position.x - half_width + char_width
		var right_limit = camera.position.x + half_width - char_width
		
		# Clamp position
		position.x = clamp(position.x, left_limit, right_limit)
