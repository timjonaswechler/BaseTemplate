class_name AudioSlider extends HSlider

signal value_changed_by_user(new_value: float)

@export var linked_spinbox: AudioSpinBox
@export_enum("Master", "Music", "SFX", "EchoSFX", "Voice", "UI", "Ambient") var target_bus: String = "Music"

func _enter_tree() -> void:
	name = "%sAudioSlider" % target_bus
	min_value = 0.0
	max_value = 100.0
	step = 1.0
	
	drag_ended.connect(audio_slider_drag_ended)
	value_changed.connect(_on_value_changed)
	
	if linked_spinbox:
		linked_spinbox.target_bus = target_bus
		linked_spinbox.value_changed.connect(_on_spinbox_value_changed)
		value_changed_by_user.connect(linked_spinbox.set_value)

func _ready() -> void:
	value = AudioManager.get_actual_volume_db_from_bus(target_bus) * 100.0
	if linked_spinbox:
		linked_spinbox.value = value

func _on_value_changed(new_value: float) -> void:
	value_changed_by_user.emit(new_value)

func _on_spinbox_value_changed(new_value: float) -> void:
	if value != new_value:
		value = new_value

func audio_slider_drag_ended(volume_changed: bool):
	if volume_changed:
		var normalized_value = value / 100.0
		if (target_bus == "SFX"):
			AudioManager.change_volume("EchoSFX", normalized_value)
		AudioManager.change_volume(target_bus, normalized_value)
		SettingsHandler.update_audio_section(target_bus, normalized_value)
		Log.info("Volume of %s is set to %s" % [target_bus, normalized_value])
