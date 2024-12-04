extends HBoxContainer
class_name Vector2Element

signal value_changed(new_value: Vector2)

var label : Label = Label.new()
var vector : VBoxContainer = VBoxContainer.new()

var x_input = SpinBox.new()
var y_input = SpinBox.new()
@export var max_x_value = 1000
@export var min_x_value = 0
@export var step_x_value = 1

@export var max_y_value = 1000
@export var min_y_value = 0
@export var step_y_value = 1

@export var default_value : Array = [250,250]
@export var name_ : String
func _ready(label_:String = name_, value_: Array = default_value, x_setup_ : Array[int] = [min_x_value,max_x_value,step_x_value], y_setup_ : Array[int] = [min_y_value,max_y_value,step_y_value]) -> void:
	name = label_
	setupLabel(label_)
	setupVector(value_, x_setup_, y_setup_)
	
	add_child(label)
	add_child(vector)
func add(label_:String = name_, value_: Array = default_value, x_setup_ : Array[int] = [min_x_value,max_x_value,step_x_value], y_setup_ : Array[int] = [min_y_value,max_y_value,step_y_value]) -> void:
	name = label_
	setupLabel(label_)
	setupVector(value_, x_setup_, y_setup_)
	
	add_child(label)
	add_child(vector)
	
func setupLabel(text: String):
	label.name = str(name ,"Label")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.text = text
	
	
func setupVector(_values : Array, x_setup_: Array[int], y_setup_: Array[int]):
	vector.name = str(name ,"Vector")
	
	var x_container = HBoxContainer.new()
	var x_label = Label.new()
	x_label.text = "x"
	x_label.add_theme_color_override("font_color", Color("bf4a36"))
	x_input.name = str(vector.name , "Xinput")
	x_input.value = _values[0]
	x_input.min_value = x_setup_[0]
	x_input.max_value = x_setup_[1]
	x_input.step = x_setup_[2]
	
	var y_container = HBoxContainer.new()
	var y_label = Label.new()
	y_label.text = "y"
	y_label.add_theme_color_override("font_color", Color("44b865"))
	y_input.name = str(vector.name , "Yinput")
	y_input.value = _values[1]
	y_input.min_value = y_setup_[0]
	y_input.max_value = y_setup_[1]
	y_input.step = y_setup_[2]
	
	x_container.add_child(x_label)
	x_container.add_child(x_input)
	y_container.add_child(y_label)
	y_container.add_child(y_input)
	vector.add_child(x_container)
	vector.add_child(y_container)
	
	x_input.connect("value_changed", Callable(self, "_on_x_input_value_changed"))
	y_input.connect("value_changed", Callable(self, "_on_y_input_value_changed"))
	
func get_width():
	return [label.size.x,vector.size.x]

func set_width(_size : Array):
	label.custom_minimum_size.x = _size[0]
	vector.custom_minimum_size.x = _size[1]

func _on_x_input_value_changed(value: float) -> void:
	emit_signal("value_changed", Vector2(value, y_input.value))

func _on_y_input_value_changed(value: float) -> void:
	emit_signal("value_changed", Vector2(x_input.value, value))	
	
func data() -> Vector2:
	return Vector2(x_input.value,y_input.value)
