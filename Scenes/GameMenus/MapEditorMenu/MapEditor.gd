extends Control

@onready var gradient : Gradient = Gradient.new()
@onready var noise : FastNoiseLite = FastNoiseLite.new()
@onready var sprite = $Sprite2D
@onready var texture = $Sprite2D.texture
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
#@onready var noise = 
var update : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	rng.randi()
	
	# https://github.com/neki-dev/gen-biome?tab=readme-ov-file
	# Initialize gradient with height-based color stops
	gradient
	gradient.add_point(-1.0, Color(0.12, 0.12, 0.12))  # < -8200m
	gradient.add_point(-0.94, Color(0.86, 0.47, 0.80))  # -7670
	gradient.add_point(-0.88, Color(0.74, 0.43, 0.63))  # -6940
	gradient.add_point(-0.82, Color(0.67, 0.31, 0.84))  # -6210
	gradient.add_point(-0.76, Color(0.53, 0.31, 0.71))  # -5480
	gradient.add_point(-0.70, Color(0.31, 0.12, 0.57))  # -4750
	gradient.add_point(-0.64, Color(0.12, 0.06, 0.78))  # -4020
	gradient.add_point(-0.58, Color(0.06, 0.25, 0.78))  # -3290
	gradient.add_point(-0.52, Color(0.06, 0.43, 0.86))  # -2560
	gradient.add_point(-0.46, Color(0.12, 0.59, 0.94))  # -2240
	gradient.add_point(-0.40, Color(0.12, 0.74, 1.0))   # -1920
	gradient.add_point(-0.34, Color(0.35, 0.88, 0.96))  # -1600
	gradient.add_point(-0.28, Color(0.24, 0.74, 0.86))  # -1280
	gradient.add_point(-0.22, Color(0.47, 0.74, 0.86))  # -960
	gradient.add_point(-0.16, Color(0.67, 0.74, 0.86))  # -640
	gradient.add_point(-0.10, Color(0.82, 0.86, 0.82))  # -320
	gradient.add_point(-0.04, Color(0.59, 0.86, 0.59))  # 0
	gradient.add_point(0.02, Color(0.25, 0.78, 0.29))   # 320
	gradient.add_point(0.08, Color(0.35, 0.69, 0.29))   # 640
	gradient.add_point(0.14, Color(0.47, 0.59, 0.33))   # 960
	gradient.add_point(0.20, Color(0.39, 0.39, 0.24))   # 1280
	gradient.add_point(0.26, Color(0.29, 0.18, 0.14))   # 1600
	gradient.add_point(0.32, Color(0.51, 0.31, 0.08))   # 1920
	gradient.add_point(0.38, Color(0.63, 0.39, 0.10))   # 2240
	gradient.add_point(0.44, Color(0.74, 0.51, 0.12))   # 2560
	gradient.add_point(0.50, Color(0.90, 0.67, 0.08))   # 3290
	gradient.add_point(0.56, Color(0.98, 0.90, 0.04))   # 4020
	gradient.add_point(0.62, Color(0.98, 0.55, 0.0))    # 4750
	gradient.add_point(0.68, Color(0.90, 0.27, 0.0))    # 5480
	gradient.add_point(0.74, Color(0.98, 0.0, 0.0))     # 6210
	gradient.add_point(0.80, Color(0.98, 0.37, 0.37))   # 6940
	gradient.add_point(0.86, Color(0.98, 0.71, 0.60))   # 7670
	gradient.add_point(0.92, Color(0.98, 0.98, 0.98))   # > 8400
	gradient.set_interpolation_mode(Gradient.GRADIENT_INTERPOLATE_CONSTANT)
	update = true
	%FreqSlider.min_value = 0.0001
	%FreqSlider.step = 0.0001
	
	pass	
func _process(delta: float) -> void:
	if update:
		sprite.texture.color_ramp = gradient
		update = false
	pass
	


func _on_vector_2_element_value_changed(new_value: Vector2) -> void:
	texture.width = new_value[0]
	texture.height = new_value[1]
	
	pass # Replace with function body.

func _on_seed_slider_value_changed(value: float) -> void:
	texture.noise.seed = value
	update = true
	pass # Replace with function body.


func _on_freq_slider_value_changed(value: float) -> void:
	texture.noise.frequency = value
	update = true
	pass # Replace with function body.

func _on_fractal_octaves_slider_value_changed(value: float) -> void:
	texture.noise.set_fractal_octaves(value)
	$MarginContainer/VBoxContainer/FractalOctaves/FractalOctavesLabel.text = ("%s") % value
	update = true
	pass # Replace with function body.


func _on_fractal_lacunarity_slider_value_changed(value: float) -> void:
	texture.noise.set_fractal_lacunarity(value)
	$MarginContainer/VBoxContainer/Smothness/FractalLacunarityLabel.text = ("%s") % value
	update = true
	pass # Replace with function body.
