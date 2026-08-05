extends MachineComponent

var torque = 500

func _process(delta: float) -> void:
  super(delta)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
  super(state)
  if is_playing:
    apply_torque(torque)

func get_bolt_point() -> Vector2:
  return global_position
