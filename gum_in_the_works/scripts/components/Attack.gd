extends Node2D

class_name Attack

@export var attack_damage : int = 10

func _process(delta):
	if Input.is_action_pressed("attack"):
		pass
	
