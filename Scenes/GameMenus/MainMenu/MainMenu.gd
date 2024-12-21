class_name MainMenu
extends Control
signal locale_changed
#region Constants
#endregion

#region Static Variables
#endregion

#region Static Methods
#endregion

#region Exported Variables
@export var about_packed_scene: PackedScene
@export var mapEditor_packed_scene: PackedScene
@export var mods_packed_scene: PackedScene
@export var multiplayer_packed_scene: PackedScene
@export var settings_packed_scene: PackedScene
@export var singleplayer_packed_scene: PackedScene
@export var wiki_packed_scene: PackedScene
#endregion

#region Ready Variables
@onready var m_languageSelection = %LanguageSelection
#endregion

#region Public Variables
var sub_menu
#endregion

#region Method Overrides
func _ready():
	locale_changed.connect(_on_ui_update)
	_setupVersion()
	_setupLanguageseletion()
	
	# Vereinfachtes Setup
	_setupButtons()
	_on_ui_update()

	
#endregion

#region Private Methods
func _setupVersion():
	%VersionButton.text = ProjectSettings.get_setting("application/config/version")
	
func _setupLanguageseletion():
	# TODO: POPUP should be rewritten for language selection.
	LocalizationHandler.loadLanguages()
	
	var selected_language = SettingsHandler.get_localization_section(GameSettings.CurrentLanguageSetting)
	var selectedIndex: int
	var optionIndex = 0
	
	for locale_code in TranslationServer.get_loaded_locales():
		if locale_code == selected_language:
			selectedIndex = optionIndex
		var localizationIndex = LocalizationHandler.findLanguage(locale_code)
		%LanguageSelection.add_item(
			LocalizationHandler.available_languages[localizationIndex].native_name +
			" - " + LocalizationHandler.available_languages[localizationIndex].iso_code)

		%LanguageSelection.get_popup().set_item_as_radio_checkable(localizationIndex, false)
		optionIndex += 1
		
	%LanguageSelection.select(selectedIndex)
	
	
func _setupButtons():
	%SingleplayerButton.visible = singleplayer_packed_scene != null
	%MultiplayerButton.visible = multiplayer_packed_scene != null
	%WikiButton.visible = wiki_packed_scene != null
	%MapEditorButton.visible = mapEditor_packed_scene != null
	%SettingsButton.visible = settings_packed_scene != null
	%ModsButton.visible = mods_packed_scene != null
	%AboutButton.visible = about_packed_scene != null

func _on_singleplayer_button_pressed() -> void:
	if singleplayer_packed_scene:
		SceneTransitionManager.transition_to_scene(singleplayer_packed_scene, true)

func _on_multiplayer_button_pressed() -> void:
	if multiplayer_packed_scene:
		SceneTransitionManager.transition_to_scene(multiplayer_packed_scene, true)

func _on_wiki_button_pressed() -> void:
	if wiki_packed_scene:
		SceneTransitionManager.transition_to_scene(wiki_packed_scene, true)

func _on_map_editor_button_pressed() -> void:
	if mapEditor_packed_scene:
		SceneTransitionManager.transition_to_scene(mapEditor_packed_scene, true)

func _on_settings_button_pressed() -> void:
	if settings_packed_scene:
		SceneTransitionManager.transition_to_scene(settings_packed_scene, true)

func _on_mods_button_pressed() -> void:
	if mods_packed_scene:
		SceneTransitionManager.transition_to_scene(mods_packed_scene, true)

func _on_about_button_pressed() -> void:
	if about_packed_scene:
		SceneTransitionManager.transition_to_scene(about_packed_scene, true)

func _input(event):
	if event.is_action_released("ui_cancel"):
		get_tree().quit()
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		%MenuButtonsBoxContainer.focus_first()

func _on_exit_button_pressed() -> void:
	# https://github.com/godotengine/godot/issues/64320
	get_tree().quit()

func _on_back_button_pressed() -> void:
	pass
	#_close_sub_menu()
	
func _on_language_selection_item_selected(index: int) -> void: #
	LocalizationHandler.setLanguage(index)

func _on_ui_update() -> void:
	%SingleplayerButton.text = tr(TranslationKeys.Menu["singleplayer"])
	%MultiplayerButton.text = tr(TranslationKeys.Menu["multiplayer"])
	%SettingsButton.text = tr(TranslationKeys.Menu["settings"])
	%AboutButton.text = tr(TranslationKeys.Menu["about"])
	%MapEditorButton.text = tr(TranslationKeys.Menu["mapeditor"])
	%WikiButton.text = tr(TranslationKeys.Menu["wiki"])
	%ExitButton.text = tr(TranslationKeys.General["exit"])
	%BackButton.text = tr(TranslationKeys.General["back"])
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		locale_changed.emit()
		
#endregion

#region Private Variables
#endregion
