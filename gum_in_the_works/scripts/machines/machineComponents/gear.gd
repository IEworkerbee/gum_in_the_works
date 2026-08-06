extends MachineComponent

func _process(delta: float) -> void:
	super(delta)

func get_bolt_points():
	return [global_position]

func get_max_bolts():
	return 1
