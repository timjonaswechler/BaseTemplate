extends Node
class_name MapSettings

#region Constants
#endregion

#region Static Variables
#endregion

#region Static Methods
#endregion

#region Exported Variables
@export var mapResourceType: Enums.MapResourceType
#endregion

#region Ready Variables
var customMapSettingsPrefab = preload("res://Scenes/CustomMapSettings.tscn")
#endregion

#region Public Variables
#endregion

#region Method Overrides
func _ready():
	_load_map_resource()
	pass
	
#endregion

#region Public Methods
#endregion

#region Private Methods
func _on_submit_received(data: Dictionary) -> void:
	print("Received data:", data)

	# Falls ein bestehendes benutzerdefiniertes Map-Setting vorhanden ist, lösche es
	if m_customMapSettingsInstance:
		m_customMapSettingsInstance.queue_free()
		m_customMapSettingsInstance = null  # Referenz zurücksetzen

	# Erstelle eine neue benutzerdefinierte Ressource aus dem Dictionary
	m_mapResource = _create_map_resource_from_data(data)
	# Überprüfe die Karte auf Validität
	if !_is_map_valid():
		push_error("Your map size values must be a multiple of your chunk sizes!")
		if m_mapResource.debugMode:
			breakpoint

func _create_map_resource_from_data(data: Dictionary) -> MapResource:
	var new_map_resource = MapResource.new()
	
	if data.has("bevelFactor"):
		new_map_resource.bevelFactor = data["bevelFactor"]
	if data.has("cellOrientation"):
		new_map_resource.cellOrientation = data["cellOrientation"]["value"]
	if data.has("cellSize"):
		new_map_resource.cellSize = data["cellSize"]
	if data.has("cellSurfaceFactor"):
		new_map_resource.cellSurfaceFactor = data["cellSurfaceFactor"]
	if data.has("chunkSize"):
		new_map_resource.chunkSize = data["chunkSize"]
	if data.has("columnRowLayout"):
		new_map_resource.columnRowLayout = data["columnRowLayout"]["value"]
	if data.has("debugMode"):
		new_map_resource.debugMode = data["debugMode"]
	if data.has("elevationStepHeight"):
		new_map_resource.elevationStepHeight = data["elevationStepHeight"]
	if data.has("mapSize"):
		new_map_resource.mapSize = data["mapSize"]

	return new_map_resource

func _load_map_resource() -> void:
	match mapResourceType:
		Enums.MapResourceType.DEBUG:
			m_mapResource = load("res://Assets/Resources/DebugMap.tres")
		Enums.MapResourceType.SMALL:
			m_mapResource = load("res://Assets/Resources/SmallMap.tres")
		Enums.MapResourceType.MEDIUM:
			m_mapResource = load("res://Assets/Resources/MediumMap.tres")
		Enums.MapResourceType.LARGE:
			m_mapResource = load("res://Assets/Resources/LargeMap.tres")
		Enums.MapResourceType.CUSTOM:
			_setup_custom_map()
			return
	print(m_mapResource)
	if !_is_map_valid():
		push_error("Your map size values must be a multiple of your chunk sizes!")
		if m_mapResource.debugMode:
			breakpoint

func _setup_custom_map() -> void:
	m_customMapSettingsInstance = customMapSettingsPrefab.instantiate()
	add_child(m_customMapSettingsInstance)
	
	m_customMapSettingsInstance.connect("submit_pressed", Callable(self, "_on_submit_received"))

func _is_map_valid() -> bool:
	return (m_mapResource.mapSize.x % m_mapResource.chunkSize.x == 0 and m_mapResource.mapSize.y % m_mapResource.chunkSize.y == 0)
#endregion

#region Private Variables
var m_customMapSettingsInstance: Node = null
var m_mapResource: MapResource
var m_debug_mode: bool
#endregion
