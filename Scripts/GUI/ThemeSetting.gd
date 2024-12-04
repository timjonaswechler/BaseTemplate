class_name ThemeSetting
extends Node

enum HeadingType {H1, H2, H3, H4, H5, H6}
enum Alignment {LEFT, CENTER, RIGHT}

const FONT_SIZE = 24
const FONT_NORMAL_PATH = "res://Assets/Fonts/Open_Sans/OpenSans-VariableFont_wdth,wght.ttf"
const FONT_ITALIC_PATH = "res://Assets/Fonts/Open_Sans/OpenSans-Italic-VariableFont_wdth,wght.ttf"

const FONT_SIZE_H1 = 2.5 * ThemeSetting.FONT_SIZE # 5rem
const FONT_SIZE_H2 = 2 * ThemeSetting.FONT_SIZE # 4.5rem
const FONT_SIZE_H3 = 1.75 * ThemeSetting.FONT_SIZE # 4rem
const FONT_SIZE_H4 = 1.5 * ThemeSetting.FONT_SIZE # 3.5rem
const FONT_SIZE_H5 = 1.25 * ThemeSetting.FONT_SIZE # 3rem
const FONT_SIZE_H6 = 1 * ThemeSetting.FONT_SIZE # 2.5rem

const FONT_EXTRABOLD = 900
const FONT_BOLD = 700
const FONT_SEMIBOLD = 600
const FONT_REGULAR = 400
const FONT_LIGHT = 300
const FONT_EXTRALIGHT = 200



# Farben als geschachtelte Klasse
class ColorSettings:
	const blue = Color("0d6efd");
	const indigo = Color("6610f2");
	const purple = Color("6f42c1");
	const pink = Color("d63384");
	const red = Color("dc3545");
	const orange = Color("fd7e14");
	const yellow = Color("ffc107");
	const green = Color("198754");
	const teal = Color("20c997");
	const cyan = Color("0dcaf0");
	const black = Color("000");
	const white = Color("fff");
	const gray = Color("6c757d");
	const gray_dark = Color("343a40");
	const gray_100 = Color("f8f9fa");
	const gray_200 = Color("e9ecef");
	const gray_300 = Color("dee2e6");
	const gray_400 = Color("ced4da");
	const gray_500 = Color("adb5bd");
	const gray_600 = Color("6c757d");
	const gray_700 = Color("495057");
	const gray_800 = Color("343a40");
	const gray_900 = Color("212529");
	const primary = Color("0d6efd");
	const secondary = Color("6c757d");
	const success = Color("198754");
	const info = Color("0dcaf0");
	const warning = Color("ffc107");
	const danger = Color("dc3545");
	const light = Color("f8f9fa");
	const dark = Color("212529");
	const primary_text_emphasis = Color("052c65");
	const secondary_text_emphasis = Color("2b2f32");
	const success_text_emphasis = Color("0a3622");
	const info_text_emphasis = Color("055160");
	const warning_text_emphasis = Color("664d03");
	const danger_text_emphasis = Color("58151c");
	const light_text_emphasis = Color("495057");
	const dark_text_emphasis = Color("495057");
	const primary_bg_subtle = Color("cfe2ff");
	const secondary_bg_subtle = Color("e2e3e5");
	const success_bg_subtle = Color("d1e7dd");
	const info_bg_subtle = Color("cff4fc");
	const warning_bg_subtle = Color("fff3cd");
	const danger_bg_subtle = Color("f8d7da");
	const light_bg_subtle = Color("fcfcfd");
	const dark_bg_subtle = Color("ced4da");
	const primary_border_subtle = Color("9ec5fe");
	const secondary_border_subtle = Color("c4c8cb");
	const success_border_subtle = Color("a3cfbb");
	const info_border_subtle = Color("9eeaf9");
	const warning_border_subtle = Color("ffe69c");
	const danger_border_subtle = Color("f1aeb5");
	const light_border_subtle = Color("e9ecef");
	const dark_border_subtle = Color("adb5bd");
	
#   --bs-body-font-size: 1rem;
#   --bs-body-font-weight: 400;
#   --bs-body-line-height: 1.5;
#   --bs-body-color: #212529;
#   --bs-body-bg: #fff;
#   --bs-emphasis-color: #000;
#   --bs-secondary-color: rgba(33, 37, 41, 0.75);
#   --bs-secondary-bg: #e9ecef;
#   --bs-tertiary-color: rgba(33, 37, 41, 0.5);
#   --bs-tertiary-bg: #f8f9fa;
#   --bs-link-color: #0d6efd;
#   --bs-link-decoration: underline;
#   --bs-link-hover-color: #0a58ca;
#   --bs-code-color: #d63384;
#   --bs-highlight-color: #212529;
#   --bs-highlight-bg: #fff3cd;
#   --bs-border-width: 1px;
#   --bs-border-color: #dee2e6;
#   --bs-border-color-translucent: rgba(0, 0, 0, 0.175);
#   --bs-border-radius: 0.375rem;
#   --bs-border-radius-sm: 0.25rem;
#   --bs-border-radius-lg: 0.5rem;
#   --bs-border-radius-xl: 1rem;
#   --bs-border-radius-xxl: 2rem;
#   --bs-border-radius-2xl: var(--bs-border-radius-xxl);
#   --bs-border-radius-pill: 50rem;
#   --bs-box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
#   --bs-box-shadow-sm: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
#   --bs-box-shadow-lg: 0 1rem 3rem rgba(0, 0, 0, 0.175);
#   --bs-box-shadow-inset: inset 0 1px 2px rgba(0, 0, 0, 0.075);
#   --bs-focus-ring-width: 0.25rem;
#   --bs-focus-ring-opacity: 0.25;
#   --bs-focus-ring-color: rgba(13, 110, 253, 0.25);
#   --bs-form-valid-color: #198754;
#   --bs-form-valid-border-color: #198754;
#   --bs-form-invalid-color: #dc3545;
#   --bs-form-invalid-border-color: #dc3545;

const colors = ColorSettings
var FONT_NORMAL = FontVariation.new();
var FONT_ITALIC = FontVariation.new();
var ts = TextServerManager.get_primary_interface()

func _init() -> void:
	FONT_NORMAL.base_font = load(ThemeSetting.FONT_NORMAL_PATH)
	FONT_ITALIC.base_font = load(ThemeSetting.FONT_ITALIC_PATH)
