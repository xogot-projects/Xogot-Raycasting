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


func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var turn_dir : float = Input.get_axis("turn_right", "turn_left")
	var horizonal_vel = Vector3(velocity.x, 0, velocity.z)
	
	if not is_on_floor():
		var custom_gravity = get_gravity() * delta
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
	
	velocity.x = horizonal_vel.x
	velocity.z = horizonal_vel.z
	move_and_slide()
	run_animations()
	
	
func run_animations():
	# if the player is on the floor and velocity equals 0 for all Vector3 values, the player is idle
	if is_on_floor() && velocity == Vector3.ZERO:
		animated.play("Idle")
	# if the player is on the floor but velocity is not equal to 0 on all Vector3 values, the player is walking
	elif is_on_floor() && velocity != Vector3.ZERO:
		animated.play("Walk")
	# otherwise the player is in the air - either jumping or falling
	else:
		animated.play("Jump")
	
	
