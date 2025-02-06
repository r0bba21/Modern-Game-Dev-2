extends Camera3D

@export var sensitivity: float = 0.03 # LOWER = MORE INPUT
@export var deadzone: float = 0.05
@export var smooth_speed: float = 1.75  # HIGHER = FASTER
@export var noise_strength: float = 0.4
@export var noise_speed: float = 0.1
var rotation_input = Vector2.ZERO
var base_rotation = Vector3(-14.8, 160, 0)  # DEFAULT
var min_rotation: Vector3
var max_rotation: Vector3
var target_rotation: Vector3

var noise := FastNoiseLite.new()
var time_passed := 0.0

func _ready():
	# Set initial rotation
	rotation_degrees = base_rotation
	target_rotation = base_rotation

	# Define min and max rotation limits based on deadzone
	min_rotation = base_rotation - Vector3(1, 1, 0)
	max_rotation = base_rotation + Vector3(1, 1, 0)

	# Set up noise parameters
	noise.seed = randi()
	noise.frequency = 0.5  # Controls smoothness of noise

func _input(event):
	if event is InputEventMouseMotion:
		# Get mouse delta (change in position)
		var mouse_delta = event.relative * sensitivity

		# Apply deadzone check
		if mouse_delta.length() < deadzone:
			return

		# Update target rotation (X for up/down, Y for left/right)
		target_rotation.y -= mouse_delta.x  # Rotate left/right
		target_rotation.x -= mouse_delta.y  # Rotate up/down

		# Clamp target rotation within the deadzone range
		target_rotation.x = clamp(target_rotation.x, min_rotation.x, max_rotation.x)
		target_rotation.y = clamp(target_rotation.y, min_rotation.y, max_rotation.y)

func _process(delta):
	time_passed += delta * noise_speed

	# Generate smooth noise sway
	var noise_x = noise.get_noise_1d(time_passed) * noise_strength
	var noise_y = noise.get_noise_1d(time_passed + 100) * noise_strength  # Offset Y for variation

	# Blend noise with player-controlled target rotation
	var final_target_rotation = target_rotation
	final_target_rotation.x += noise_x
	final_target_rotation.y += noise_y

	# Smoothly interpolate current rotation towards the noisy target rotation
	rotation_degrees = rotation_degrees.lerp(final_target_rotation, delta * smooth_speed)
