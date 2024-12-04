extends HBoxContainer
class_name DropDownMenu

var options: OptionButton = OptionButton.new()
var label: Label = Label.new()

func add(_label: String, _options: Array, default_value: String = "") -> void:
	name = _label
	
	setupLabel(_label)
	setupOptions(_options, default_value)
	
	add_child(label)
	add_child(options)

func setupLabel(text: String):
	label.name = str(name, "Label")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.text = text

func setupOptions(_optionsArray: Array, default_value: String):
	options.name = str(name, "Options")
	options.alignment = HORIZONTAL_ALIGNMENT_LEFT

	var popup_menu = options.get_popup()
	if typeof(_optionsArray[0]) == TYPE_STRING:
		for option in _optionsArray:
			popup_menu.add_item(option)
	else:
		for option in _optionsArray:
			popup_menu.add_item(str(option))
	
	# Set all items as non-checkable
	popup_menu.hide_on_checkable_item_selection
	
	# Set the default value if provided
	if default_value != null:
		var index = _optionsArray.find(default_value)
		if index != -1:
			options.select(index)
		else:
			options.select(0)

func get_width():
	return [label.size.x, options.size.x]

func set_width(_size: Array):
	label.custom_minimum_size.x = _size[0]
	options.custom_minimum_size.x = _size[1]

func data() -> int:
	return options.selected
