class_name H1
extends PanelContainer

var padding: MarginContainer = MarginContainer.new()
var font: FontVariation
var label: Label = Label.new()
var style: H1Style

# Initialisiere die H1-Klasse
func add(text_: String, style: H1Style = H1Style.new(), theme_ : ThemeSetting = ThemeSetting.new(),):
	label.text = text_
	name = str(text_,"H1")
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if style.alignment == ThemeSetting.Alignment.LEFT:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT 
	elif style.alignment == ThemeSetting.Alignment.CENTER:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	elif style.alignment == ThemeSetting.Alignment.RIGHT:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	if style.font_normal:
		font = theme_.FONT_NORMAL
		font.variation_opentype = {theme_.ts.name_to_tag("wght"): style.font_weight}
	else:
		font = theme.FONT_ITALIC
		font.variation_opentype = {theme_.ts.name_to_tag("wght"): style.font_weight}
	label.add_theme_font_override("font",font)
	label.add_theme_font_size_override("font_size", style.font_size)
	label.add_theme_color_override("font_color",style.color)
	
	padding.add_child(label)
	padding.add_theme_constant_override("margin_top",style.padding.x)
	padding.add_theme_constant_override("margin_right",style.padding.y)
	padding.add_theme_constant_override("margin_bottom",style.padding.z)
	padding.add_theme_constant_override("margin_left",style.padding.w)
	
	var styleBox: StyleBoxFlat = StyleBoxFlat.new()
	styleBox.bg_color = style.background_color
	add_theme_stylebox_override("panel", styleBox)
	
	add_child(padding)
