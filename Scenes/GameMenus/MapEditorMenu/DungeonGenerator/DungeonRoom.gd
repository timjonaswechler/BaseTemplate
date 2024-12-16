class_name DungeonRoom
extends Node2D


var velocity := Vector2(0, 0)
var acceleration := Vector2(0, 0)


## Whether the node is pinned down. If true, the node will not move.
@export var pinned_down: bool = false
## The radius of the node.
@export var size: Vector2i = Vector2i(50, 50)
## The mass of the node.
@export var mass := 1
## The repulsion force of the node.
@export var repulsion := 0.3
## The minimum distance between nodes.
@export var min_distance := 50.0
## The maximum speed of the node.
@export var MAX_SPEED = 5
## The minimum speed of the node.
@export var MIN_SPEED = 0.1
## The drag of the node.
@export var DRAG := 0.7


@export_category("Visuals")
## Whether to draw the node as a point.
@export var draw_point: bool = false: set = _set_draw_point
## The color of the point.
@export var point_color: Color = Color.WHITE: set = _set_point_color
var rng = RandomNumberGenerator.new()

func _init(i):
	rng.randomize()
	
	position = Vector2(rng.randi_range(1920/2-100, 1920/2+100), rng.randi_range(1080/2-100,1080/2+100))
	print(position)
	name = "Room " + str(i)
	size = Vector2i(randi_range(25, 100), randi_range(25, 100))
	mass = size.x + size.y
	repulsion = 0.3
	min_distance = randi_range(50, 150)
	MAX_SPEED = 1.0
	MIN_SPEED = 0.1
	DRAG = 0.7
	draw_point = true
	point_color = Color(rng.randf_range(0.2, 0.8), rng.randf_range(0.2, 0.8), rng.randf_range(0.2, 0.8), 1)
	# Connect signals
	connect("child_exiting_tree", _on_child_exiting_tree)
	connect("child_entered_tree", _on_child_entered_tree)
	


func _draw():
	if draw_point:
		draw_rect(Rect2(Vector2.ZERO, size),point_color)
		#draw_circle(Vector2.ZERO, size.x, point_color)


## Accelerates the node by the given force.
func accelerate(force: Vector2) -> void:
	# Calculate acceleration (F = m*a)
	acceleration += force / mass


## Repulses the node from the given node.
func repulse(other_node: Node) -> void:
	if position.distance_to(other_node.position) > sqrt(size.x^2+size.y^2) + min_distance:
		return

	# Calculate force
	var force := position.direction_to(other_node.position) * repulsion

	# Apply force
	accelerate(-force)


## Updates the position of the node based on its velocity and acceleration.
func update_position():
	# Stop if pinned down
	if pinned_down:
		return

	# Update velocity
	velocity += acceleration*100
	print(velocity)
	# Reduce velocity by drag
	velocity *= DRAG

	# Limit velocity to max speed
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
	
	# Stop if velocity is too low^
	if velocity.length() < MIN_SPEED:
		velocity = Vector2.ZERO

	# Update position
	position += velocity
	

	# Reset acceleration
	acceleration = Vector2.ZERO


func _on_child_exiting_tree(child):
	var parent := get_parent()
	if parent.is_node_ready():
		parent.update_graph_simulation()


func _on_child_entered_tree(child):
	var parent := get_parent()
	if parent.is_node_ready():
		parent.update_graph_simulation()


func _get_configuration_warnings():
	var warnings: Array = []

	if not (get_parent() is DungeonGeneratorGraph):
		warnings.append("Node is not a child of a DungeonGeneratorGraph.")
	
	return warnings


func _set_draw_point(value: bool):
	draw_point = value
	queue_redraw()


func _set_point_color(value: Color):
	point_color = value
	queue_redraw()
