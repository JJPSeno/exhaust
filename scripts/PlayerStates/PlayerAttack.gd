extends State
class_name PlayerAttack

@export var animation_player: AnimationPlayer

func Enter():
	print("attack state")
	animation_player.play("attack")

func attack_finished():
	Transitioned.emit(self, "PlayerIdle")
