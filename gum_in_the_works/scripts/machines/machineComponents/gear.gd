extends MachineComponent

func _process(delta: float) -> void:
	super(delta)

func get_bolt_point() -> Vector2:
	return global_position
