extends CharacterBody2D

const SPEED = 300.0
const ROTATION_SPEED = 3.0  # Rotation speed in radians per second
const THRUST_FORCE = 500.0  # Force applied when shooting forward

func _ready():
	# Connect the signal once at initialization
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	# Handle animation
	if Input.is_action_pressed("ui_up"):
		# Only start "Deploy" if not already playing an animation
		if not $AnimationPlayer.is_playing() or $AnimationPlayer.current_animation == "":
			$AnimationPlayer.play("Deploy")
		# If already playing "Loop", do nothing
	else:
		# When key is released, stop animation and reset to beginning of Deploy
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Deploy")
		$AnimationPlayer.seek(0.0, true)
		$AnimationPlayer.stop()
	
	# Handle rotation
	var rotation_input = Input.get_axis("ui_left", "ui_right")
	if rotation_input:
		rotation += rotation_input * ROTATION_SPEED * delta
	
	# Handle thrust/momentum when up is pressed
	if Input.is_action_pressed("ui_up"):
		# Calculate direction vector based on current rotation
		var direction = Vector2(sin(rotation), -cos(rotation)).rotated(PI/2)
		
		# Apply force in that direction
		velocity += direction * THRUST_FORCE * delta
	
	# Apply friction/drag to gradually slow down
	velocity = velocity.lerp(Vector2.ZERO, 0.01)
	
	var viewport_size = get_viewport().size
	
	# Check if character is at or beyond boundaries
	if position.x <= -viewport_size.x / 2:
		position.x = -viewport_size.x / 2
		velocity.x = max(0, velocity.x)  # Only allow moving right
	elif position.x >= viewport_size.x / 2:
		position.x = viewport_size.x / 2
		velocity.x = min(0, velocity.x)  # Only allow moving left
		
	if position.y <= -viewport_size.y / 2:
		position.y = -viewport_size.y / 2
		velocity.y = max(0, velocity.y)  # Only allow moving down
	elif position.y >= viewport_size.y / 2:
		position.y = viewport_size.y / 2
		velocity.y = min(0, velocity.y)  # Only allow moving up
	
	# Move the character
	move_and_slide()

func _on_animation_finished(anim_name: String):
	# If "Deploy" just finished and the key is still pressed, play "Loop"
	if anim_name == "Deploy" and Input.is_action_pressed("ui_up"):
		$AnimationPlayer.play("Loop")
	# If key was released during "Deploy", make sure we reset to beginning of Deploy
	elif anim_name == "Deploy" and not Input.is_action_pressed("ui_up"):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Deploy")
		$AnimationPlayer.seek(0.0, true)
		$AnimationPlayer.stop()
		
