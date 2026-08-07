extends TextureRect

# Auto generated names get a lil funky and mess up 
# logic with get_node, so I have to make my own unique identifiers
var id = 0
var body_count = 0

@export var scene: PackedScene

@onready var area2d: Area2D = $Area2D

func _ready() -> void:
	area2d.body_entered.connect(_on_body_entered)
	area2d.body_exited.connect(_on_body_exited)
	spawn_scene()

func _on_body_entered(_body: Node2D) -> void:
	body_count += 1

func _on_body_exited(_body: Node2D) -> void:
	body_count -= 1
	if body_count <= 0:
		spawn_scene()

func spawn_scene():
	var new_scene = scene.instantiate()
	new_scene.name += str(id)
	id += 1
	new_scene.global_position = global_position + (size / 2)
	new_scene.spawner = true
	var parent = get_parent()
	if parent is MachineCase:
		parent.add_child.call_deferred(new_scene)
	else:
		push_error("Parent is not a instance of a class that can be spawned to.")