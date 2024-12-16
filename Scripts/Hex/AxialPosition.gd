class_name AxialPosition

var q: int
var r: int

func _init(_q: int, _r: int) -> void:
		q = _q
		r = _r
func _to_string() -> String:
	return str("(", q, ", ", r, ")")
	
func as_vector2i() -> Vector2i:
	return Vector2i(q, r)

static func from_vector2i(v: Vector2i) -> AxialPosition:
	return AxialPosition.new(v.x, v.y)
	
static func axial_round(a: AxialPosition) -> AxialPosition:
	return from_cube(CubePosition.round(to_cube(a)))
	
static func from_cube(a: CubePosition) -> AxialPosition:
	return AxialPosition.new(a.q, a.r)
	
static func to_cube(a: AxialPosition) -> CubePosition:
	var _s = a.q - a.r
	return CubePosition.new(a.q, a.r, _s)

static func neighbor(hex: AxialPosition, _direction: HexDirection.HexDirections) -> AxialPosition:
	var hex_directions = [AxialPosition.new(1, -1), AxialPosition.new(0, -1), AxialPosition.new(-1, 0),
						  AxialPosition.new(-1, 1), AxialPosition.new(0, 1), CubePosition.new(1, 0)]
	return AxialPosition.add(hex, hex_directions(_direction))

static func diagonal_neighbor(hex: AxialPosition, _direction: HexDirection.HexDiagonalDirections) -> AxialPosition:
	var hex_diagonals = [AxialPosition.new(1, -2), AxialPosition.new(-1, -1), AxialPosition.new(-2, 1),
						 AxialPosition.new(-1, 2), AxialPosition.new(1, 1), AxialPosition.new(2, -1), ]
	return AxialPosition.add(hex, hex_diagonals[_direction])

	
static func particial_axial_to_cube(_q: int, _r: int) -> CubePosition:
	var _s = _q - _r
	return CubePosition.new(_q, _r, _s)
	
static func to_world(a: AxialPosition) -> Vector3:
	var x = HexCell.size * (sqrt(3) * a.q + sqrt(3) / 2 * a.r)
	var z = HexCell.size * (3. / 2 * a.r)
	return Vector3(x, 0.0, z)

static func from_world(w: Vector3) -> AxialPosition:
	var _q = (sqrt(3) / 3 * w.x - 1. / 3 * w.z) / HexCell.size
	var _r = (2. / 3 * w.z) / HexCell.size
	var a = AxialPosition.new(_q, _r)
	return AxialPosition.axial_round(a)
