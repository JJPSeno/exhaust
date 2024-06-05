extends Node3D

@onready var human = $HumanModel
@onready var human_head = $HumanModel/HumanHead
@onready var human_camera = $HumanModel/HumanHead/HumanCamera

@onready var motorcycle = $MotorcycleModel
@onready var motorcycle_head = $MotorcycleModel/MotorcycleHead
@onready var motorcycle_camera = $MotorcycleModel/MotorcycleHead/MotorcycleCamera

@export var is_human = true

#Human vars:
const SPEED = 12.0
const JUMP_VELOCITY = 12.5
const SENSITIVITY = .002
const base_gravity = 20
const fall_gravity = 20 * 3
var gravity
#Motorcycle vars:
const MAX_STEER = 0.8
const ENGINE_POWER = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	human_camera.current = true
	motorcycle_camera.current = false
	motorcycle.set_process(false)
	motorcycle.visible = false
	
	gravity = base_gravity
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		motorcycle_head.rotate_y(-event.relative.x * SENSITIVITY)
		human_head.rotate_y(-event.relative.x * SENSITIVITY)
		transform.basis = Basis(Vector3(0,1,0), -event.relative.x * SENSITIVITY) * transform.basis
		motorcycle_camera.rotate_x(-event.relative.y * SENSITIVITY)
		motorcycle_camera.rotation.x = clamp(motorcycle_camera.rotation.x, deg_to_rad(-40), deg_to_rad(40))
		human_camera.rotate_x(-event.relative.y * SENSITIVITY)
		human_camera.rotation.x = clamp(human_camera.rotation.x, deg_to_rad(-40), deg_to_rad(40))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit(0)
	
	if Input.is_action_just_pressed("toggle_form"):
		if is_human:
			human.set_process(false)
			human.visible = false
			motorcycle_camera.current = true
			motorcycle.set_process(true)
			motorcycle.visible = true
			is_human = false
		else:
			motorcycle.set_process(false)
			motorcycle.visible = false
			human_camera.current = true
			human.set_process(true)
			human.visible = true
			is_human = true
	if is_human:
		if not human.is_on_floor():
			human.velocity.y -= gravity * delta
		if human.velocity.y < 0:
			gravity = fall_gravity
		elif human.velocity.y >= 0:
			gravity = base_gravity
		# Handle jump.
		if Input.is_action_just_pressed("jump") and human.is_on_floor():
			human.velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			human.velocity.x = direction.x * SPEED
			human.velocity.z = direction.z * SPEED
		else:
			human.velocity.x = 0
			human.velocity.z = 0
		human.move_and_slide()
	else:
		motorcycle.steering = move_toward(motorcycle.steering, Input.get_axis("right", "left") * MAX_STEER, delta * 2.5)
		motorcycle.engine_force = Input.get_axis("back", "forward") * ENGINE_POWER

