extends MarginContainer
class_name VersionLabel

#region Constants
#endregion

#region Static Variables
#endregion

#region Static Methods
#endregion

#region Exported Variables
#endregion

#region Ready Variables
#endregion

#region Public Methods
#endregion

#region Public Variables
func add(_label: String) -> void:
	name = _label
	_setupLabel(_label)
	add_child(m_label)
#endregion

#region Method Overrides
func _ready() -> void:
	name = "VersionLabel"
	var margin_value = 8
	add_theme_constant_override("margin_top", margin_value)
	add_theme_constant_override("margin_left", margin_value)
	add_theme_constant_override("margin_bottom", margin_value)
	add_theme_constant_override("margin_right", margin_value)
	
#endregion

#region Private Methods
func _setupLabel(text: String):
	m_label.name = str(name, "Label")
	m_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	m_label.text = text

#endregion

#region Private Variables
var m_label = Label.new()
#endregion
