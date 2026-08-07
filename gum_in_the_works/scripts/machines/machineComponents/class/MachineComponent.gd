class_name MachineComponent
extends RigidBody2D

var draggable = false
var offset: Vector2
var do_restore = false
var hovering = false
var bolt_points_visible = false
var init_state = {
	"transform" = global_transform,
	"linear_velocity" = linear_velocity,
	"angular_velocity" = angular_velocity,
}
var bolts: Array[String] = []
@onready var sprite = $Sprite2D
@export var bolt_points: Array[Button]
@export var max_bolts: int

func _ready() -> void:
	EventBus.toggle_play_machine_sim.connect(_on_toggle_play_machine_sim)
	for button in bolt_points:
		button.pressed.connect(_on_bolt_button_pressed.bind(button))

func _process(_delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true;

		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if do_restore:
		state.transform = init_state.transform
		state.linear_velocity = init_state.linear_velocity
		state.angular_velocity = init_state.angular_velocity
		do_restore = false

##### SIGNAL HANDLERS ######

func _on_area_2d_mouse_entered():
	if !Global.is_playing:
		if !Global.is_dragging and !Global.is_boltmode and bolts.is_empty():
			draggable = true
			sprite.scale = Vector2(1.125, 1.125)
		if !Global.is_dragging and Global.is_boltmode:
			display_bolt_points()
	hovering = true

func _on_area_2d_mouse_exited():
	if !Global.is_dragging and !Global.is_playing:
		draggable = false;
	sprite.scale = Vector2(1, 1)
	hide_bolt_points()
	hovering = false

func _on_toggle_play_machine_sim():
	if Global.is_playing:
		save_init_state()
		hide_bolt_points()
		sprite.scale = Vector2(1, 1)
	else:
		sleeping = false
		load_init_state()
	gravity_scale = 1.0 if Global.is_playing else 0.0
	if hovering == true:
		_on_area_2d_mouse_entered()

func _on_bolt_button_pressed(bolt_point: Button):
	if bolts.has(bolt_point.name):
		var bolt_sprite: Sprite2D = get_node(String("Sprite" + bolt_point.name + name))
		var pin_joint: PinJoint2D = get_parent().get_node(String("PinJoint" + bolt_point.name + name))
		bolt_sprite.queue_free()
		await bolt_sprite.tree_exited
		pin_joint.queue_free()
		await pin_joint.tree_exited
		bolts.erase(bolt_point.name)
	else:
		var bolt_position: Vector2 = bolt_point.global_position + (bolt_point.size / 2)
		var pin_joint: PinJoint2D = PinJoint2D.new()
		pin_joint.name = "PinJoint" + bolt_point.name + name
		pin_joint.global_position = bolt_position
		pin_joint.node_a = get_parent().get_node("Static-backboard").get_path()
		pin_joint.node_b = self.get_path()
		get_parent().add_child(pin_joint)

		var bolt_sprite: Sprite2D = Sprite2D.new()
		bolt_sprite.name = "Sprite" + bolt_point.name + name
		add_child(bolt_sprite)
		bolt_sprite.texture = load("res://assets/images/machineComponents/bolt.png")
		bolt_sprite.global_position = bolt_position
		bolts.append(bolt_point.name)

##### HELPER FUNCTIONS #####

func display_bolt_points():
	# Make bolt points visible
	if !bolt_points_visible:
		for i in bolt_points:
			i.visible = true
		bolt_points_visible = true

func hide_bolt_points():
	if bolt_points_visible:
		for i in bolt_points:
			i.visible = false
		bolt_points_visible = false

func save_init_state():
	init_state.transform = global_transform
	init_state.linear_velocity = linear_velocity
	init_state.angular_velocity = angular_velocity

func load_init_state():
	do_restore = true