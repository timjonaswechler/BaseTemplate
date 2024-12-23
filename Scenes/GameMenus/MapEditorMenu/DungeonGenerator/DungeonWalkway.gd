@tool
class_name DungeonWalkway
extends Line2D


signal connection_changed


var connection: Line2D


@export var length := 500.0
@export var K := 0.005
@export var node_start: DungeonRoom: set = _connect_node_start
@export var node_end: DungeonRoom: set = _connect_node_end

@export_category("Line")
@export var draw_line: bool = true


func _ready():
	width = 2.0


## Connects the two nodes to the spring
func connect_nodes(start, end):
	node_start = start
	node_end = end


## Adds force to the connected nodes
func move_nodes():
	if node_start == null or node_end == null:
		return

	var force: Vector2 = node_end.position - node_start.position
	var magnitude = K * (force.length() - length)

	force = force.normalized() * magnitude

	node_start.accelerate(force)
	node_end.accelerate(-force)


## Updates the line's position vector points
func update_line():
	# Clear the points
	connection.clear_points()

	if not draw_line:
		return

	if node_start == null or node_end == null:
		return

	# Add updated points
	connection.add_point(node_start.position)
	connection.add_point(node_end.position)


func _connect_node_start(node):
	node_start = node
	connection_changed.emit()


func _connect_node_end(node):
	node_end = node
	connection_changed.emit()


func _get_configuration_warnings():
	var warnings: Array = []

	if not (get_parent() is DungeonRoom):
		warnings.append("The DungeonWalkway should be a child of a DungeonRoom")
	
	if node_start == null or node_end == null:
		warnings.append("The DungeonWalkway should have two nodes connected to it")
	
	return warnings
