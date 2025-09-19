extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var scene_weeping = preload("res://scenes/entities/plants/weeping_sugarbells.tscn")
var weeping_instance = scene_weeping.instantiate()

func _ready():
	var pos: Vector2i = Vector2i(2, 2)
	weeping_instance.position = pos
	add_child(weeping_instance)
	
	
