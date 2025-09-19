extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var scene_ribose_crystal = preload("res://scenes/entities/ribose_crystal.tscn")
var scene_mother_gum = preload("res://scenes/entities/mother_gum.tscn")
var ribose_crystal_instance
var mother_gum_instance
var pos: Vector2i = Vector2i(-3, -2)

func _ready():
	mother_gum_instance = scene_mother_gum.instantiate()
	mother_gum_instance.global_position = tile_map_layer.map_to_local(Vector2i(0, -1))
	mother_gum_instance.global_position.y += 8
	mother_gum_instance.y_sort_enabled = true
	add_child(mother_gum_instance)    

func _process(_delta: float):
	if is_instance_valid(ribose_crystal_instance) == false:
		ribose_crystal_instance = scene_ribose_crystal.instantiate()
		ribose_crystal_instance.global_position = tile_map_layer.map_to_local(pos)
		ribose_crystal_instance.global_position.y += 16
		ribose_crystal_instance.y_sort_enabled = true
		add_child(ribose_crystal_instance)
		
		
	
	
