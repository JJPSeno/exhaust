extends Node3D

const SENSITIVITY = .002

var motorcycleRes = preload("res://scenes/motorcycle.tscn")
var humanRes = preload("res://scenes/playerv2.tscn")
var is_human = true

func _ready():
	var human = humanRes.instantiate()
	add_child(human)
	
func _process(delta):
	if Input.is_action_just_pressed("toggle_form"):
		#make this a call down, signal up pattern ig?
		if is_human:
			var player = get_node("Playerv2")
			global_position = player.global_position
			player.queue_free()
			var motorcycle = motorcycleRes.instantiate()
			add_child(motorcycle)
			is_human = false
		else:
			var motorcycle = get_node("Motorcycle")
			global_position = motorcycle.global_position
			motorcycle.queue_free()
			var human = humanRes.instantiate()
			add_child(human)
			is_human = true
