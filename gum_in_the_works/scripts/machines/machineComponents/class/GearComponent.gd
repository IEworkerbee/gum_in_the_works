extends MachineComponent
class_name GearComponent

var snapPointPositions: Array[Vector2]
var snapPoints: Array[Node2D]
var dx: float
var dy: float

@export var distance_snappoints: float
@export var SNAP_POINT: PackedScene

func _ready() -> void:
	super()
	snapPointPositions.resize(6)
	snapPoints.resize(6)
	dx = cos(deg_to_rad(30)) * distance_snappoints
	dy = sin(deg_to_rad(30)) * distance_snappoints
	# Generate snappoints:
	for i in 6:
		var snapPoint = SNAP_POINT.instantiate()
		snapPoint.name = "SnapPoint" + str(i)
		snapPoints[i] = snapPoint
		add_child(snapPoint)
	snapPointPositions[0] = Vector2(0, distance_snappoints)
	snapPointPositions[1] = Vector2(dx, dy)
	snapPointPositions[2] = Vector2(dx, -dy)
	snapPointPositions[3] = Vector2(0, -distance_snappoints)
	snapPointPositions[4] = Vector2(-dx, -dy)
	snapPointPositions[5] = Vector2(-dx, dy)
		
func on_place():
	super()
	for i in 6:
		if is_valid_spot(snapPointPositions[i] + global_position):
			snapPoints[i].get_node("Area2D").monitoring = true
			snapPoints[i].global_position = snapPointPositions[i] + global_position

func on_drag():
	super()
	stop_monitoring()

func stop_monitoring():
	for i in 6:
		snapPoints[i].get_node("Area2D").monitoring = false