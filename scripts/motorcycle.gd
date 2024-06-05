extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 300
const SENSITIVITY = .002
@onready var head = $Head
@onready var camera = $Head/Camera3D

# Called when the node enters the scene tree for the first time.

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		transform.basis = Basis(Vector3(0,1,0), -event.relative.x * SENSITIVITY) * transform.basis
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(40))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 2.5) 
	engine_force = Input.get_axis("back", "forward") * ENGINE_POWER

	
