extends OptionButton
class_name DropDown

func add(_label: String, _options: Array, default_value: String = "") -> void:
	name = _label
	setupOptions(_options, default_value)
	

func setupOptions(_optionsArray: Array, default_value: String):
	name = str(name, "Options")
	alignment = HORIZONTAL_ALIGNMENT_LEFT


	if typeof(_optionsArray[0]) == TYPE_STRING:
		for option in _optionsArray:
			add_item(option)
	else:
		for option in _optionsArray:
			add_item(str(option))
	
	# Set the default value if provided
	if default_value != null:
		var index = _optionsArray.find(default_value)
		if index != -1:
			select(index)
		else:
			select(0)
	
	for i in _optionsArray.size():
		get_popup().set_item_as_radio_checkable(i,false)

func data() -> int:
	return selected
