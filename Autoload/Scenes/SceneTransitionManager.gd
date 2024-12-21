extends Node

signal transition_started
signal transition_completed

var transition_layer: CanvasLayer
var transition_rect: ColorRect
var animation_player: AnimationPlayer

func _ready() -> void:
	_setup_transition_layer()

func _setup_transition_layer() -> void:
	transition_layer = CanvasLayer.new()
	transition_layer.layer = 100
	
	transition_rect = ColorRect.new()
	transition_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	transition_rect.color = Color.BLACK
	transition_rect.modulate.a = 0
	transition_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	animation_player = AnimationPlayer.new()
	
	transition_layer.add_child(transition_rect)
	transition_rect.add_child(animation_player)
	add_child(transition_layer)
	
	_create_animations()

func _create_animations() -> void:
	var fade_animation = Animation.new()
	var track_index = fade_animation.add_track(Animation.TYPE_VALUE)
	fade_animation.track_set_path(track_index, ".:modulate:a") # Pfad korrigiert
	fade_animation.length = 1.0 # Animation verlängern
	fade_animation.track_insert_key(track_index, 0.0, 0.0)
	fade_animation.track_insert_key(track_index, 1.0, 1.0) # Zeitpunkt angepasst
	
	var animation_lib = AnimationLibrary.new()
	animation_lib.add_animation("fade", fade_animation)
	
	animation_player.add_animation_library("transition_animation", animation_lib)
	

func transition_to_scene(scene: PackedScene, fade: bool = true) -> void:
	print("Starting scene transition...") # Debug
	
	if fade:
		transition_started.emit()
		# Korrigierte Animation mit Bibliotheksname
		animation_player.play("transition_animation/fade")
		await animation_player.animation_finished
		
	get_tree().change_scene_to_packed(scene)
	
	if fade:
		# Korrigierte Animation mit Bibliotheksname
		animation_player.play_backwards("transition_animation/fade")
		await animation_player.animation_finished
		transition_completed.emit()
