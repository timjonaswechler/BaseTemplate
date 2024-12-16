extends HBoxContainer
class_name CheckButtonElement

var checkButton : CheckBox = CheckBox.new()
var label : Label = Label.new()

func add(_label:String, _checkBoxDefault: bool) -> void:
	name = _label
	
	m_setupLabel(_label)
	m_setupCheckBox(_checkBoxDefault)
	
	add_child(label)
	add_child(checkButton)
	
	pass

func m_setupLabel(text: String):
	label.name = str(name ,"Label")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.text = text
	pass
	
func m_setupCheckBox(_value: bool):
	checkButton.name = str(name ,"CheckButton")
	checkButton.alignment = HORIZONTAL_ALIGNMENT_LEFT
	checkButton.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	checkButton.button_pressed = _value
	pass
	
func get_width():
	return [label.size.x,checkButton.size.x]

func set_width(_size : Array):
	label.custom_minimum_size.x = _size[0]
	checkButton.custom_minimum_size.x = _size[1]
	pass
func data() -> bool:
	return checkButton.button_pressed
