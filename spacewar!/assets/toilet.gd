extends CharacterBody2D

var POO = preload("res://assets/poo.tscn")

const SPEED = 300.0
const ROTATION_SPEED = 3.0  # Rotation speed in radians per second
const THRUST_FORCE = 500.0  # Force applied when shooting forward
const GRAVITY_SPEED = 0.1

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
	
	velocity += _get_gravity_vec() * GRAVITY_SPEED * delta
	
	# Handle bullets
	if Input.is_action_just_pressed("ui_down") and not get_parent().has_node("poopy pants"):
		var bullet = POO.instantiate()
		bullet.position = position
		bullet.direction = Vector2.RIGHT.rotated(rotation)
		bullet.name = "poopy pants"
		get_parent().add_child(bullet)
	
	# Apply friction/drag to gradually slow down
	velocity = velocity.lerp(Vector2.ZERO, 0.01)
	
	var viewport_size = get_viewport().size
	
	# Check if character is at or beyond boundaries
	if position.x <= -viewport_size.x / 2:
		position.x = viewport_size.x / 2
	elif position.x >= viewport_size.x / 2:
		position.x = -viewport_size.x / 2
	
	if position.y <= -viewport_size.y / 2:
		position.y = viewport_size.y / 2
	elif position.y >= viewport_size.y / 2:
		position.y = -viewport_size.y / 2
	
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
	
func _get_gravity_vec():
	return Vector2(0, 0) - position
		
