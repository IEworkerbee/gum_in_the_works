extends CharacterBody2D

@onready var _player: AnimatedSprite2D = $AnimatedSprite2D
@onready var _interacting_area: Area2D = $InteractingArea

@export var speed := 200
@export var inventory: Inventory

var facing : String = "forward_idle"

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _ready():
	inventory.ready() # Initializer for resource
	_player.play(facing)

func _physics_process(_delta): 
	get_input()
	move_and_slide()
	
func _process(_delta):
	if Input.is_action_pressed("right"):
		_player.play("walk_right")
		facing = "right_idle"
	elif Input.is_action_pressed("left"):
		_player.play("walk_left")
		facing = "left_idle"
	elif Input.is_action_pressed("up"):
		_player.play("walk_backward")
		facing = "backward_idle"
	elif Input.is_action_pressed("down"):
		_player.play("walk_forward")
		facing = "forward_idle"
	elif Input.is_action_just_pressed("interact"):
		for body in _interacting_area.get_overlapping_bodies():
			if body.is_in_group("harvestable"):
				var item: Inv_Item = body.harvest()
				inventory.add_item(item)
				body.queue_free()
				return 1
			elif body.name == "MotherGum":
				var success: int = inventory.remove_item(body.get_item_to_consume())
				if success == 1:
					# Expansion code here
					pass
				return 1
			
	else:
		_player.stop()
		_player.play(facing)
