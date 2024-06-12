extends State
class_name PlayerIdle

@export var animation_player: AnimationPlayer

func Enter():
	print("idle state")
	animation_player.play("idle")

func State_Update(_delta: float):
	if Input.is_action_just_pressed("attack_melee"):
		Transitioned.emit(self,"PlayerAttack")
	
