extends CharacterBody2D

@onready var _player = $AnimatedSprite2D
@export var speed = 200

var facing = "forward_idle"

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _ready():
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
	else:
		_player.stop()
		_player.play(facing)
