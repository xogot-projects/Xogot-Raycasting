extends CharacterBody3D

@onready var animated = $axolotl/AnimationPlayer

# Movement Variables
@export_category("Movement")
@export var move_speed : float = 5.0
@export var turn_speed : float = 5.0

# Jump Variables
@export_group("Jump Physics")
@export var max_height: float = 2.0
@export var air_speed: float = 7.0       
@export var fall_weight: float = 1.6
@export_range(0.0, 1.0, 0.1) var partial_momentum: float = 0.3
@export_range(0.0, 1.0, 0.01) var jump_steering: float = 0.5  

@onready var Front : Node = $FrontRay
@onready var Back : Node = $BackRay

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var turn_dir : float = Input.get_axis("turn_right", "turn_left")
	var horizonal_vel = Vector3(velocity.x, 0, velocity.z)
	var custom_gravity = get_gravity() * delta

	if not is_on_floor():
		velocity += custom_gravity * (fall_weight if velocity.y < 0 else 1.0)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = sqrt(2.0 * abs(get_gravity().y) * max_height)
	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= partial_momentum

	rotate_y(turn_speed * turn_dir * delta)
	
	if is_on_floor():
		if direction:
			horizonal_vel = direction * move_speed
		else:
			horizonal_vel = horizonal_vel.move_toward(Vector3.ZERO, move_speed * 2.0 * delta)
	else:
		if horizonal_vel.length() < 0.1:
			horizonal_vel = direction * air_speed
		elif direction:
			horizonal_vel = horizonal_vel.lerp(direction * air_speed, jump_steering)
		# Otherwise slow to a stop if directional input stops
		else:
			horizonal_vel = horizonal_vel.move_toward(Vector3.ZERO, air_speed * delta)
	
	velocity.x = horizonal_vel.x
	velocity.z = horizonal_vel.z
	move_and_slide()


	# Raycasting goes after move_and_slide so that is runs after the movement is calculated
	# Otherwise it might lag behind
	# Making sure the raycast updates keeps it synched with the movement
	Front.force_raycast_update() 
	Back.force_raycast_update()

	var front_hit = Front.is_colliding() # Check if the front ray is colliding
	var back_hit = Back.is_colliding() # Check if the back ray is colliding
	var tilt = deg_to_rad(10) # Number of degrees to tilt if the player is partially over an edge

	if front_hit and back_hit: # If both rays are colliding, the player is on a surface
		var target_normal = (Front.get_collision_normal() + Back.get_collision_normal()).normalized() # Average the upward direction of the surface colliding with both rays, then normalizes the length to prevent distortion
		var target_forward = -global_basis.z.slide(target_normal).normalized() # Find the forward direction and slide it to match the slope of the surface, using the target_normal to recognize the slope
		var target_basis = Basis.looking_at(target_forward, target_normal) # The Player's future orientation found by rotating the basis (which are local axes that controls rotation/scale) using the new orientation and upward direction
		global_basis = global_basis.slerp(target_basis, 12 * delta) # Smoothly transition from the current orientation to the new orientation
	elif back_hit and not front_hit: # Only the player's back is colliding, so the front is in the air
		global_rotation.x = lerp_angle(global_rotation.x, global_rotation.x - tilt, 5.0 * delta) # Transition to a tilted rotation (current rotation, new rotation, weight of change)
		if direction.is_zero_approx(): # If the player stops partially over the ledge
			velocity += -global_basis.z * 0.3 # Add a tiny bit of velocity in the direction of movement to make the player fall forward
	elif front_hit and not back_hit: # Only the front ray is colliding, the player's back is in the air, so tilt back:
		# Add a smooth transition between the current rotation and a tilted rotation
		global_rotation.x = lerp_angle(global_rotation.x, global_rotation.x + tilt, 5.0 * delta)
		if direction.is_zero_approx(): # if there's no movement 
			# add a tiny bit of velocity in the direction the player was moving to encourage a fall
			velocity -= -global_basis.z * 0.3
	else: # Otherwise, the player is completely in the air
		global_rotation.x = lerp_angle(global_rotation.x, 0.0, .5 * delta) # Transition back to an upright orientation to help the player land properly
	
	run_animations()
	
# Animations
func run_animations():
	if is_on_floor() && velocity == Vector3.ZERO:
		animated.play("Idle")
	elif is_on_floor() && velocity != Vector3.ZERO:
		animated.play("Walk")
	else:
		animated.play("Jump")

