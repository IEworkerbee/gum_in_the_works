extends Node2D
class_name MachineCase

# Auto generated names get a lil funky and mess up 
# logic with get_node, so I have to make my own unique identifiers
var id = 0

@export var boltmodeButton: Button
@export var gearSpawnButton: Button
@export var sourceGearSpawnButton: Button

const GEAR = preload("res://scenes/machine_components/gear.tscn")
const SOURCE_GEAR = preload("res://scenes/machine_components/sourceGear.tscn")

func _ready() -> void:
	boltmodeButton.pressed.connect(_on_boltmode)
	gearSpawnButton.pressed.connect(_on_gear_spawn)
	sourceGearSpawnButton.pressed.connect(_on_source_gear_spawn)

func _on_boltmode():
	Global.is_boltmode = !Global.is_boltmode

func _on_gear_spawn():
	var new_gear = GEAR.instantiate()
	new_gear.global_position = Vector2(0, 0)
	new_gear.name = "gear" + str(id)
	id += 1
	add_child(new_gear)

func _on_source_gear_spawn():
	var new_source_gear = SOURCE_GEAR.instantiate()
	new_source_gear.global_position = Vector2(0, 0)
	new_source_gear.name = "sourcegear" + str(id)
	id += 1
	add_child(new_source_gear)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			Global.is_playing = !Global.is_playing
			EventBus.toggle_play_machine_sim.emit()
