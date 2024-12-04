class_name CustomMapSettings
extends Control

signal submit_pressed(data: Dictionary)

var m_mapSettings : MapResource
var m_mapSizeFactor : int = 100
@onready var container = %BoxContainer

var debugCheckButton : CheckButtonElement = CheckButtonElement.new()
var layoutCellOrientation : DropDownMenu = DropDownMenu.new()
var columnRowLayout : DropDownMenu = DropDownMenu.new()
var chunkSize : Vector2Element = Vector2Element.new()
var mapSize : Vector2Element = Vector2Element.new()
var originOffset : Vector2Element = Vector2Element.new()
var firstHeadline : H1 = H1.new()
var secondHeadline : H1 = H1.new()
var thirdHeadline : H1 = H1.new()
var submitButton : Button = Button.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	firstHeadline.add("Map Settings")
	secondHeadline.add("Grid Settings")
	thirdHeadline.add("Cell Settings")
	debugCheckButton.add("Debug Mode", true)
	
	layoutCellOrientation.add("Layout", Layout.CellOrientation.keys())

	chunkSize.add("Chunk Size",
		[8,8], 
		[1,32,1], 
		[1,32,1])
	
	mapSize.add("Map Size",
		[chunkSize.x_input.value,chunkSize.y_input.value],
		[chunkSize.x_input.value,chunkSize.x_input.max_value * m_mapSizeFactor, chunkSize.x_input.value],
		[chunkSize.y_input.value,chunkSize.y_input.max_value * m_mapSizeFactor, chunkSize.y_input.value])
		
	originOffset.add("Origin Offset",
		[0,0],
		[0,mapSize.x_input.value,1],
		[0,mapSize.y_input.value,1])
		
	
	columnRowLayout.add("Column Row Layout", Layout.ColumnRowLayout.keys())
	submitButton.name = str("SubmitButton")
	submitButton.text = "Save Settings"
	
	container.add_child(firstHeadline)
	container.add_child(debugCheckButton)
	container.add_child(secondHeadline)
	container.add_child(layoutCellOrientation)
	container.add_child(columnRowLayout)
	container.add_child(chunkSize)
	container.add_child(mapSize)
	container.add_child(originOffset)
	container.add_child(thirdHeadline)
	container.add_child(submitButton)
	
	set_widths(container.get_children())
	
	chunkSize.connect("value_changed", Callable(self, "_on_chunk_size_changed"))
	mapSize.connect("value_changed", Callable(self, "_on_map_size_changed"))
	originOffset.connect("value_changed", Callable(self, "_on_origin_offset_changed"))
	submitButton.connect("pressed", Callable(self, "_on_submit_pressed"))

#TODO: Bestimmen der Max Weite ist noch ungenau
func set_widths(group): 
	var maxSizeArray = []
	var labelsizeArray = []
	var valuesizeArray = []
	
	for item in group:
		maxSizeArray.append(item.size.x)
		if item.get_children().size() > 1:
			labelsizeArray.append(item.get_width()[0])
			valuesizeArray.append(item.get_width()[1])
	
	var maxContainerSize = maxSizeArray.max()
	var maxLabelSize = labelsizeArray.max()
	var maxValueSize = valuesizeArray.max()
	var maxItemScaling = maxContainerSize/(maxLabelSize + maxValueSize)
	maxLabelSize = maxLabelSize * maxItemScaling
	maxValueSize = maxValueSize * maxItemScaling
	
	
	for item in group:
		if item.get_children().size() > 1:
			item.set_width([maxLabelSize,maxValueSize])
		else: 
			item.custom_minimum_size.x = maxContainerSize

	
func _on_chunk_size_changed(new_value: Vector2) -> void:
	#print("Chunk Size changed to: ", new_value)
	mapSize.x_input.step = new_value[0]
	mapSize.x_input.min_value = new_value[0]
	mapSize.x_input.max_value = new_value[0] * m_mapSizeFactor
	mapSize.y_input.step = new_value[1]
	mapSize.y_input.min_value = new_value[1]
	mapSize.y_input.max_value = new_value[1] * m_mapSizeFactor

func _on_map_size_changed(new_value: Vector2) -> void:
	#print("Map Size changed to: ", new_value)
	originOffset.x_input.max_value = mapSize.x_input.value
	originOffset.y_input.max_value = mapSize.y_input.value

func _on_origin_offset_changed(new_value: Vector2) -> void:
	#print("Origin Offset changed to: ", new_value)
	pass
	
func _on_submit_pressed() -> void:
	var data = {
		"debugMode" = debugCheckButton.data(),
		"layoutCellOrientation" = {
			"key" = Layout.CellOrientation.find_key(layoutCellOrientation.data()),
			"value" = layoutCellOrientation.data()},
		"columnRowLayout" = {
			"key" = Layout.ColumnRowLayout.find_key(columnRowLayout.data()),
			"value" = columnRowLayout.data()},
		"chunkSize" = chunkSize.data(),
		"mapSize" = mapSize.data(),
		"originOffset" = originOffset.data(),
	}
	emit_signal("submit_pressed",data )
