extends Node2D
class_name MachineCase

@export var boltmodeButton: Button

func _ready() -> void:
  boltmodeButton.pressed.connect(_on_boltmode)

func _on_boltmode():
  Global.is_boltmode = !Global.is_boltmode

func _input(event: InputEvent) -> void:
  if event is InputEventKey and event.pressed:
    if event.keycode == KEY_P:
      Global.is_playing = !Global.is_playing
      EventBus.toggle_play_machine_sim.emit()
