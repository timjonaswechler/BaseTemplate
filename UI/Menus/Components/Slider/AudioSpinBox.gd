class_name AudioSpinBox extends SpinBox

signal value_changed_by_user(new_value: float)

var target_bus: String

func _enter_tree() -> void:
	name = "%sAudioSpinBox" % target_bus
	
	min_value = 0.0
	max_value = 100.0
	step = 1.0
	suffix = "%"
	
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	value_changed_by_user.emit(new_value)
