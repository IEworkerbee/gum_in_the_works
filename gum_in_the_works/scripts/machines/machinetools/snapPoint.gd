extends Node2D

@onready var area2d: Area2D = $Area2D

func _ready():
	area2d.body_entered.connect(_on_area_entered)
	area2d.body_exited.connect(_on_area_exited)

func _on_area_entered(body: Node2D):
	print(body.name)
	if body is RigidBody2D:
		print(body.name)

func _on_area_exited(body: Node2D):
	if body is RigidBody2D:
		print(body.name)