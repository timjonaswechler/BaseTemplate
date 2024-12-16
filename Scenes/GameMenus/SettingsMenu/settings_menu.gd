extends Control
class_name SettingsMenu

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
	# Get all labels and find the one that is the longest in pixels (x direction)
	var labels = []
	for element in get_node("BoxContainer").get_children():
		for childElement in element.get_children():
			if childElement is Label:
				labels.append(childElement)
				
	var max_width = 0	
	for label in labels:
		if label is Label:
			var width = label.size.x
			if width > max_width:
				max_width = width

	# Set all labels to have the same width
	for label in labels:
		if label is Label:
			label.custom_minimum_size = Vector2(max_width + 10,label.size.y)
	## TODO: Wenn ein neue ELement während der LaufZeit hinzu kommt wird das aktuell nicht in der Auswahl aufgeführt. 
	# Aktuallisierung der Liste muss anders erstellt werden, evtl. wenn man auf den SettingsButton drückt. das würde Eigentlich schon als prüf schleife reichen. 
	
	for device in AudioManager.get_available_audio_devices():
		$BoxContainer/AudoDeviceSetting/OptionButton.add_item(device)
	for i in range(AudioManager.get_available_audio_devices().size()):
		if AudioManager.get_available_audio_devices()[i] == AudioManager.get_current_audio_device():
			$BoxContainer/AudoDeviceSetting/OptionButton.select(i)
			
	
	
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
#endregion


func _on_option_button_item_selected(index: int) -> void:
	var device = AudioManager.get_available_audio_devices()[index]
	AudioManager.set_audio_device(device)
	SettingsHandler.update_audio_section(GameSettings.CurrentAudioOutputDeviceSetting, device)
	pass # Replace with function body.
