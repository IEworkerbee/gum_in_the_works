extends Node2D

class_name Plant

@export var growth_sprites: Array[Texture2D]

@onready var sprite: Sprite2D = $"../Sprite2D"

var fully_grown: bool = false
var indx: int = 0
var random_num: int
var time_elapse: float
var timer: Timer
var processing_sig: bool = true

func _ready():
	sprite.texture = growth_sprites[indx]

func _process(delta: float):
	if fully_grown == false and processing_sig:
		_timer_grow()

func grow() -> int:
	if fully_grown == false:
		indx += 1
		sprite.texture = growth_sprites[indx]
		if indx == growth_sprites.size() - 1:
			fully_grown = true
		return 1
	else:
		return 0

func _timer_grow():
	processing_sig = false
	randomize()
	random_num = randi_range(5, 10)
	await get_tree().create_timer(random_num).timeout
	self.grow()
	processing_sig = true
