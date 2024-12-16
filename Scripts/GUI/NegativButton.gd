extends Button
class_name NegativButton

#region Constants
#endregion

#region Static Variables
#endregion

#region Static Methods
#endregion

#region Exported Variables
#endregion

#region Ready Variables
func _ready() -> void:
	var normal_style = StyleBoxFlat.new()
	var hovered_style = StyleBoxFlat.new()
	normal_style.bg_color = normal_color
	hovered_style.bg_color = hover_color
	add_theme_stylebox_override("normal",normal_style)
	add_theme_stylebox_override("hover",hovered_style)
	add_theme_color_override("font_color",Color(0.2,0.2,0.2))
	add_theme_color_override("font_hover_color",Color(0.2,0.2,0.2))
	
	pass
#endregion

#region Public Variables
#endregion

#region Method Overrides
#endregion

#region Public Methods
#endregion

#region Private Methods
#endregion

#region Private Variables
var normal_color = Color(1, 0.45, 0.45) # Grau
var hover_color = Color(1, 0.67, 0.67) # Orange
#endregion