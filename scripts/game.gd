extends Node3D

# This function is created automatically when the signal is connected
# The "body" parameter is used to represent whichever physics body enters the area3d
func _on_body_entered(body: Node3D) -> void:
# use a print statement for testing or troubleshooting
# This one will print the physics body that enters the area3d and adds a message as a string
	print(body, " fell off the platform")
# Call deferred waits for the current frame to finish processing before calling a new function
# This is always a good idea when loading or changing scenes
	call_deferred("_deferred_reload")

# The deferred scene reload function
func _deferred_reload():
# Access the scene tree to reload the current scene
	get_tree().reload_current_scene()

