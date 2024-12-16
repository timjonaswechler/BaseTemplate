class_name CubePosition

var q: int
var r: int
var s: int

func _init(q_: int, r_: int, s_: int) -> void:
	if valid(q, r, s):
		q = q_
		r = r_
		s = s_
	
func _to_string() -> String:
	return str("(", q, ", ", r, ", ", s, ")")
	
func as_vector3i() -> Vector3i:
	return Vector3i(q, r, s)

static func from_vector3i(v: Vector3i) -> CubePosition:
	return CubePosition.new(v.x, v.y, v.z)

static func to_world(a: CubePosition) -> Vector3:
	return AxialPosition.to_world(AxialPosition.from_cube(a))
	
static func from_world(w: Vector3) -> CubePosition:
	return AxialPosition.to_cube(AxialPosition.from_world(w))

static func valid(q_: int, r_: int, s_: int) -> bool:
	return q_ + r_ + s_ == 0
	
static func add(a: CubePosition, b: CubePosition) -> CubePosition:
	return CubePosition.new(a.q + b.q, a.r + b.r, a.s + b.s)

static func subtract(a: CubePosition, b: CubePosition) -> CubePosition:
	return CubePosition.new(a.q - b.q, a.r - b.r, a.s - b.s)

static func scale(a: CubePosition, k: int) -> CubePosition:
	return CubePosition.new(a.q * k, a.r * k, a.s * k)

static func rotate_left(a: CubePosition) -> CubePosition:
	return CubePosition.new(-a.s, -a.q, -a.r)

static func rotater_ight(a: CubePosition) -> CubePosition:
	return CubePosition.new(-a.r, -a.s, -a.q)

static func neighbor(hex: CubePosition, _direction: HexDirection.HexDirections) -> CubePosition:
	var hex_directions = [CubePosition.new(1, -1, 0), CubePosition.new(0, -1, 1), CubePosition.new(-1, 0, 1),
						  CubePosition.new(-1, 1, 0), CubePosition.new(0, 1, -1), CubePosition.new(1, 0, -1)]
	return CubePosition.add(hex, hex_directions(_direction))

static func diagonal_neighbor(hex: CubePosition, _direction: HexDirection.HexDiagonalDirections) -> CubePosition:
	var hex_diagonals = [CubePosition.new(1, -2, 1), CubePosition.new(-1, -1, 2), CubePosition.new(-2, 1, 1),
						 CubePosition.new(-1, 2, -1), CubePosition.new(1, 1, -2), CubePosition.new(2, -1, -1), ]
	return CubePosition.add(hex, hex_diagonals[_direction])

static func length(hex: CubePosition) -> int:
	return (abs(hex.q) + abs(hex.r) + abs(hex.s)) / 2

static func distance(a: CubePosition, b: CubePosition) -> int:
	return CubePosition.length(CubePosition.subtract(a, b))

static func round(h: CubePosition) -> CubePosition:
	var qi = int(round(h.q))
	var ri = int(round(h.r))
	var si = int(round(h.s))
	var q_diff = abs(qi - h.q)
	var r_diff = abs(ri - h.r)
	var s_diff = abs(si - h.s)

	if q_diff > r_diff and q_diff > s_diff:
		qi = -ri - si
	elif r_diff > s_diff:
		ri = -qi - si
	else:
		si = -qi - ri

	return CubePosition.new(qi, ri, si)

static func lerp(a: CubePosition, b: CubePosition, t: float) -> CubePosition:
	return CubePosition.new(a.q * (1.0 - t) + b.q * t, a.r * (1.0 - t) + b.r * t, a.s * (1.0 - t) + b.s * t)

static func linedraw(a: CubePosition, b: CubePosition) -> Array:
	var N = CubePosition.distance(a, b)
	var a_nudge = CubePosition.new(a.q + 1e - 06, a.r + 1e - 06, a.s - 2e - 06)
	var b_nudge = CubePosition.new(b.q + 1e - 06, b.r + 1e - 06, b.s - 2e - 06)
	var results = []
	var step = 1.0 / max(N, 1)

	for i in range(0, N + 1):
		results.append(CubePosition.round(CubePosition.lerp(a_nudge, b_nudge, step * i)))
		
	return results
