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
		interact()
	else:
		_player.stop()
		_player.play(facing)

func interact():
	var interactables: Array[Node2D]
	var bodies: Array[Node2D] = _interacting_area.get_overlapping_bodies()
	interactables = bodies.filter(filter_interactable)
	if interactables.size() != 0:
		interactables.sort_custom(sort_by_priority)
		interactables[0].interact()

func sort_by_priority(a: Node2D, b: Node2D):
	return a.priority < b.priority
	
func filter_interactable(a: Node2D):
	return a.is_in_group("interactable")
