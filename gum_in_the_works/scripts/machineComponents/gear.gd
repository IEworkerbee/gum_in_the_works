extends Node2D

var draggable = false
var is_rotating = false
var rotation_speed = 1
var offset: Vector2

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true;

		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false

	if is_rotating:
		rotation += rotation_speed * delta

func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.125, 1.125)

func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		draggable = false;
		scale = Vector2(1, 1)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			is_rotating = !is_rotating