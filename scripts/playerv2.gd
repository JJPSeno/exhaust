extends CharacterBody3D


const SPEED = 12.0
const JUMP_VELOCITY = 12.5
const SENSITIVITY = .002
const base_gravity = 20
const fall_gravity = 20 * 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity
var is_attacking

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var animation_player = $AnimationPlayer
@onready var attack_melee_timer = $AttackMeleeTimer
@onready var hit_box = $WeaponPivot/WeaponMesh/HitBox

func _ready():
	gravity = base_gravity
	animation_player.play("idle")
	hit_box.monitorable = false
	hit_box.monitoring = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# head.rotate_y(-event.relative.x * SENSITIVITY)
		transform.basis = Basis(Vector3(0,1,0), -event.relative.x * SENSITIVITY) * transform.basis
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(40))
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if velocity.y < 0:
		gravity = fall_gravity
	elif velocity.y >= 0:
		gravity = base_gravity

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
	
	if Input.is_action_just_pressed("attack_melee"):
		attack_melee_timer.start()
		is_attacking = true
		animation_player.play("attack")



func _on_attack_melee_timer_timeout():
	is_attacking = false
	animation_player.play("idle")


func _on_hit_box_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Oof")
