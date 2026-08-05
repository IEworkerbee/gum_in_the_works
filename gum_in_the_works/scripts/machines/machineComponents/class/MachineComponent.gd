@abstract class_name MachineComponent
extends RigidBody2D


var draggable = false
var is_playing = false
var offset: Vector2
var do_restore = false
var init_state = {
	"transform" = global_transform,
	"linear_velocity" = linear_velocity,
	"angular_velocity" = angular_velocity,
}
@onready var sprite = $Sprite2D


func _process(_delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true;

		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false

func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		sprite.scale = Vector2(1.125, 1.125)

func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		draggable = false;
		sprite.scale = Vector2(1, 1)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			is_playing = !is_playing

			if is_playing:
				save_init_state()
			else:
				sleeping = false
				load_init_state()

			gravity_scale = 1.0 if is_playing else 0.0

		# Allows an machine component to be boltable
		elif event.keycode == KEY_B and draggable and !is_playing:
			if !has_node("BoltSprite2D"):
				var bolt_position: Vector2 = get_bolt_point()
				var pin_joint: PinJoint2D = PinJoint2D.new()
				pin_joint.name = "BoltPinJoint2D"
				pin_joint.global_position = bolt_position
				pin_joint.node_a = get_parent().get_node("Static-backboard").get_path()
				pin_joint.node_b = self.get_path()
				get_parent().add_child(pin_joint)

				var bolt_sprite: Sprite2D = Sprite2D.new()
				bolt_sprite.name = "BoltSprite2D"
				add_child(bolt_sprite)
				bolt_sprite.texture = load("res://assets/images/machineComponents/bolt.png")
				bolt_sprite.global_position = bolt_position
			else:
				$BoltSprite2D.queue_free()
				await $BoltSprite2D.tree_exited
				get_parent().get_node("BoltPinJoint2D").queue_free()
				await get_parent().get_node("BoltPinJoint2D").tree_exited


func save_init_state():
	init_state.transform = global_transform
	init_state.linear_velocity = linear_velocity
	init_state.angular_velocity = angular_velocity

func load_init_state():
	do_restore = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if do_restore:
		state.transform = init_state.transform
		state.linear_velocity = init_state.linear_velocity
		state.angular_velocity = init_state.angular_velocity
		do_restore = false

@abstract func get_bolt_point() -> Vector2
