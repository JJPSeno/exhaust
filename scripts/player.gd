extends CharacterBody3D
#thanks to https://www.youtube.com/playlist?list=PLtcDUwlxDv2Icr_z339h-mBjqe6DFOi0b
#and https://docs.godotengine.org/en/3.1/tutorials/3d/fps_tutorial/part_one.html


const GRAVITY = -24.8
var velo = Vector3.ZERO
const MAX_SPEED = 7
const JUMP_SPEED = 18
const ACCEL = 4.5

var dir = Vector3.ZERO

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.08

func _ready():
	camera = $CameraPivot/Camera
	rotation_helper = $CameraPivot

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	up_direction = Vector3(0, 1, 0)
	floor_max_angle = MAX_SLOPE_ANGLE
	
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("back"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			velo.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	velo.y += delta * GRAVITY

	var hvel = velo
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.lerp(target, accel * delta)
	velo.x = hvel.x
	velo.z = hvel.z
	velocity = velo
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY* -1))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
