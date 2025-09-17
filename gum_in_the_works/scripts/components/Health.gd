extends Node2D

class_name Health

@export var MAX_HEALTH: int = 10
var health: int

func _ready():
	health = MAX_HEALTH
	
func damage(attack : Attack):
	health -= attack.attack_damage
	if health <= 0:
		get_parent().queue_free()
