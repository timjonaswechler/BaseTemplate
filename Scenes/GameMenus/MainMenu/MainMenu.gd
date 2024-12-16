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
var singleplayer_scene
var multiplayer_scene
var wiki_scene
var mapEditor_scene
var settings_scene
var mods_scene
var about_scene
var sub_menu
#endregion

#region Method Overrides
func _ready():
	locale_changed.connect(_on_ui_update)
	#_loadConfig()
	_setupVersion()
	_setupLanguageseletion()
	
	_setupContinue()
	_setupSingleplayer()
	_setupMultiplayer()
	_setupWiki()
	_setupMapEditor()
	_setupSettings()
	_setupMods()
	_setupAbout()
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
	
	
func _open_sub_menu(menu: Control):
	sub_menu = menu
	sub_menu.show()
	%BackButton.show()
	%MenuContainer.hide()
	#m_versionLabel.hide()

func _close_sub_menu():
	if sub_menu == null:
		return
	sub_menu.hide()
	sub_menu = null
	%BackButton.hide()
	%MenuContainer.show()
	#m_versionLabel.show()

func _event_is_mouse_button_released(event: InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()

func _input(event):
	if event.is_action_released("ui_cancel"):
		if sub_menu:
			_close_sub_menu()
		else:
			get_tree().quit()
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		%MenuButtonsBoxContainer.focus_first()

func _setupContinue():
	pass

func _setupSingleplayer():
	if singleplayer_packed_scene == null:
		%SingleplayerButton.hide()
	else:
		singleplayer_scene = singleplayer_packed_scene.instantiate()
		singleplayer_scene.hide()
		%SingleplayerContainer.call_deferred("add_child", singleplayer_scene)

func _setupSettings():
	if settings_packed_scene == null:
		%SettingsButton.hide()
	else:
		settings_scene = settings_packed_scene.instantiate()
		settings_scene.hide()
		%SettingsContainer.call_deferred("add_child", settings_scene)

func _setupMultiplayer():
	if multiplayer_packed_scene == null:
		%MultiplayerButton.hide()
	else:
		multiplayer_scene = multiplayer_packed_scene.instantiate()
		multiplayer_scene.hide()
		%MultiplayerContainer.call_deferred("add_child", multiplayer_scene)

func _setupWiki():
	if wiki_packed_scene == null:
		%WikiButton.hide()
	else:
		wiki_scene = wiki_packed_scene.instantiate()
		wiki_scene.hide()
		%WikiContainer.call_deferred("add_child", wiki_scene)

func _setupMapEditor():
	if mapEditor_packed_scene == null:
		%MapEditorButton.hide()
	else:
		mapEditor_scene = mapEditor_packed_scene.instantiate()
		mapEditor_scene.hide()
		%MapEditorContainer.call_deferred("add_child", mapEditor_scene)

func _setupMods():
	%ModsButton.text = tr(TranslationKeys.Menu["mods"])
	if mods_packed_scene == null:
		%ModsButton.hide()
	else:
		mods_scene = mods_packed_scene.instantiate()
		mods_scene.hide()
		%ModsContainer.call_deferred("add_child", mods_scene)

func _setupAbout():
	if about_packed_scene == null:
		%AboutButton.hide()
	else:
		about_scene = about_packed_scene.instantiate()
		about_scene.hide()
		%AboutContainer.call_deferred("add_child", about_scene)

func _on_continue_button_pressed() -> void:
	_open_sub_menu(singleplayer_scene)

func _on_singleplayer_button_pressed() -> void:
	_open_sub_menu(singleplayer_scene)

func _on_multiplayer_button_pressed() -> void:
	_open_sub_menu(multiplayer_scene)

func _on_wiki_button_pressed() -> void:
	_open_sub_menu(wiki_scene)

func _on_map_editor_button_pressed() -> void:
	_open_sub_menu(mapEditor_scene)

func _on_settings_button_pressed() -> void:
	_open_sub_menu(settings_scene)

func _on_mods_button_pressed() -> void:
	_open_sub_menu(mods_scene)

func _on_about_button_pressed() -> void:
	_open_sub_menu(about_scene)

func _on_exit_button_pressed() -> void:
	# https://github.com/godotengine/godot/issues/64320
	get_tree().quit()

func _on_back_button_pressed() -> void:
	_close_sub_menu()
	
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
