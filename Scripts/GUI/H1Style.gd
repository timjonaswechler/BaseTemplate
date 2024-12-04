class_name H1Style

# Attribute wie im HTML H1 Tag
var font_size: int = ThemeSetting.FONT_SIZE_H1
var font_weight: int = ThemeSetting.FONT_BOLD
var font_normal: bool = true
var color: Color = ThemeSetting.colors.warning_text_emphasis
var alignment: ThemeSetting.Alignment = ThemeSetting.Alignment.CENTER
var background_color: Color = ThemeSetting.ColorSettings.green
var line_height: int = 1.5
var padding: Vector4i = Vector4i((font_size * (line_height - 1)) / 2, 0, (font_size * (line_height - 1)) / 2, 0)
