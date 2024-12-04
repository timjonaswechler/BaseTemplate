class_name MapResource
extends Resource

@export var debugMode : bool = false

@export var cellOrientation : Layout.CellOrientation = Layout.CellOrientation.POINTY 
@export var cellSize : float = 0.5
@export var cellSurfaceFactor : float = 0.95
@export var elevationStepHeight : float = 0.25
@export var bevelFactor : float = 0.025

#@export var mapShape : Enums.MapShape = Enums.MapShape.RECTANGLE
@export var chunkSize : Vector2i = Vector2i(8,8)
@export var mapSize : Vector2i
@export var originOffset : Vector2i
@export var columnRowLayout : Layout.ColumnRowLayout = Layout.ColumnRowLayout.ODD
