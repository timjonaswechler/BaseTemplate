class_name Layout

#region Public data members
var layoutOrientation: CellOrientation:
	get:
		return get_orientation()
	set(value):
		layoutOrientation = value
		set_orientation(value)
		set_directions(value)
var columnRowLayout: ColumnRowLayout
#endregion

#region Setters/Getters
func set_orientation(orientation_: CellOrientation) -> void:
	if orientation_ == CellOrientation.FLAT:
		m_orientation = m_layoutFlat
	else:
		m_orientation = m_layoutPointy
		
func get_orientation():
	return m_orientation
	
func set_directions(orientation_:CellOrientation) -> void:
	if orientation_ == CellOrientation.FLAT:
		m_direction = HexDirectionsFlat
		m_diagonalDirection = HexDiagonalDirectionsFlat
	else:
		m_direction = HexDirectionsPointy
		m_diagonalDirection = HexDiagonalDirectionsPointy
#endregion

#region Statc methods
static func opposite_cell(direction):
	var opposite_direction = (direction.value() + 3) % 6
	return (opposite_direction)

static func previous_cell(direction):
	var previous_direction = (direction.value() - 1 + 6) % 6
	return (previous_direction)

static func next_cell(direction):
	var next_direction = (direction.value() + 1) % 6
	return (next_direction)
#endregion

#region Private data members
var m_orientation = m_layoutFlat
var m_direction = HexDiagonalDirectionsFlat
var m_diagonalDirection = HexDiagonalDirectionsFlat
#endregion

#region Enumerations
enum HexDirectionsFlat {NE, N, NW, SW, S, SE}
enum HexDiagonalDirectionsFlat {NE, NW, W, SW, SE, E}
enum HexDirectionsPointy {NE, NW, W, SW, SE, E}
enum HexDiagonalDirectionsPointy {N, NW, SW, S, SE, NE}
enum CellOrientation {FLAT, POINTY}
enum ColumnRowLayout {EVEN, ODD}
#endregion

#region Constants    
const m_layoutPointy = [
	sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
	sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0,
	0.5]
const m_layoutFlat = [
	3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0),
	2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0,
	0.0]
#endregion 
