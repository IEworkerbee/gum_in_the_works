extends GearComponent

@export var torque = 500

func _process(delta: float) -> void:
  super(delta)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
  super(state)
  if Global.is_playing:
    apply_torque(torque)
