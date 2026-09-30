extends Node3D

@onready var player : Node = $"../Player" # Access the player node right from the start

@export var pos_track_speed : float = 5.0 # How quickly the camera position follows the player's, higher numbers will be faster
@export var rot_track_speed : float = 7.0 # How quickly the camera rotation matches the player's, lower numbers lag more

# At the start
func _ready() -> void:
	# Set the camera's global transforms to match the player's global transforms 
	# Skip this whole function if you want the camera to gradually move into position when the scene loads
	global_transform = player.global_transform

# Since we are matching the player's position/rotation (set in Physics Process),
# the camera's position/rotation must be in Physics Process in order to sync properly
func _physics_process(delta: float) -> void: 
	# Change the camera's global position to gradually transition to the player's position
	#  Using the tracking speed variable multiplied by delta as the weight
	# linear interpolation (current value, new value, weight of change)
	global_position = lerp(global_position, player.global_position, pos_track_speed * delta)
	# Change the camera's global rotation to gradually transition to the player's rotation
	# Using the tracking speed variable multiplied by delta as the weight
	global_rotation.y = lerp_angle(global_rotation.y, player.global_rotation.y, rot_track_speed * delta)