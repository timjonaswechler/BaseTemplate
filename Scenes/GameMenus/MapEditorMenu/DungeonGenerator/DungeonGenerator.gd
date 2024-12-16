class_name DungeonGeneratorGraph
extends Node2D


## The FDGNodes in the graph.
var rooms: Array[DungeonRoom]
var roomCount = 10
## The FDGSprings in the graph.
var walkways: Array[DungeonWalkway]


## The node that contains the spring connections lines.
@onready var connections = Node2D.new()


func _ready():
	# create new rooms 
	rooms = []
	for i in range(1, roomCount+1):
		var room = DungeonRoom.new(i)
		rooms.append(room)
		add_child(room)


func _process(_delta):

# 	# Calculate acceleration depending on the spring connections
# 	for spring in springs:
# 		spring.move_nodes()

 	# Calculate repulsion between nodes
	for room in rooms:
		for other_room in rooms:
			if room != other_room:
				room.repulse(other_room)
	
# 	# Update the spring lines
# 	for spring in springs:
# 		spring.update_line()
	
 	# Update the node positions
	for room in rooms:
		room.update_position()
		print("UpdatePosition")


# ## Updates the nodes and springs arrays.
# func update_graph_simulation():
# 	# Update the nodes and springs arrays
# 	update_graph_elements()
# 	# Update the spring connections
# 	update_connections()


# ## Fills the nodes and springs arrays with the nodes and springs.
# func update_graph_elements():
# 	# Clear the nodes and springs arrays
# 	nodes = []
# 	springs = []

# 	for child in get_children():
# 		if child is DungeonRoom:
# 			nodes.append(child)
# 			for other_child in child.get_children():
# 				if other_child is DungeonWalkway:
# 					# Connect signal if not already connected
# 					if not other_child.is_connected("connection_changed", _on_connection_changed):
# 						other_child.connect("connection_changed", _on_connection_changed)
					
# 					springs.append(other_child)


# ## Updates the connections node with the springs.
# func update_connections():
# 	for child in connections.get_children():
# 		child.clear_points()
# 		connections.remove_child(child)
# 		child.queue_free()
	
# 	for spring in springs:
# 		var line = Line2D.new()
		
# 		# Copy the spring's Line2D properties
# 		line.name = spring.name

# 		line.width = spring.width
# 		line.width_curve = spring.width_curve
# 		line.default_color = spring.default_color

# 		line.gradient = spring.gradient
# 		line.texture = spring.texture
# 		line.texture_mode = spring.texture_mode

# 		line.joint_mode = spring.joint_mode
# 		line.begin_cap_mode = spring.begin_cap_mode
# 		line.end_cap_mode = spring.end_cap_mode

# 		line.sharp_limit = spring.sharp_limit
# 		line.round_precision = spring.round_precision
# 		line.antialiased = spring.antialiased

# 		# Add the line to the connections node
# 		connections.add_child(line)

# 		# Set the spring's Line2D connection to the new line
# 		spring.connection = line

# 		# Update line
# 		spring.update_line()


# func _on_connection_changed():
# 	update_graph_simulation()


# func _set_update_graph(value: bool):
# 	update_graph_simulation()


#func _on_child_entered_tree(child: Node):
	#update_graph_simulation()
#
#
#func _on_child_exiting_tree(child: Node):
	#update_graph_simulation()


# func _get_configuration_warnings():
# 	var warnings: Array = []

# 	if get_parent() is DungeonRoom or get_parent() is DungeonWalkway:
# 		warnings.append("The ForceDirectedGraph should not be a child of a FDGNode or FDGSpring.")
	
# 	return warnings
