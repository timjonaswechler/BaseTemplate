class_name HexCell
extends Node3D

#region Static member
static var size : float = 0.5
#endregion

#region Private data members
#endregion

#region Public data members
var is_in_view: bool
var cube_pos : CubePosition
var info_label = Label3D.new()
var color = Color.MAGENTA
var elevation: int:
	get:
		return elevation
	set(value):
		#Check to see if the new value is different from the existing value
		if (elevation == value):
			return
		
		elevation = value
		position.y = elevation
		info_label.position.y = position.y + 0.01 
		
		#Refresh this hex's chunk
		#_refresh()
var chunk : HexChunk
var neigbors: Array[HexCell] = [null, null, null, null, null, null]
#endregion

#region Public Methods
func with_data(_q: int, _r: int, _s: int) -> HexCell:
	if CubePosition.valid(_q,_r,_s):
		cube_pos = CubePosition.new(_q,_r,_s)
	name = str(cube_pos)
	info_label.position = Vector3(0,0.001,0)
	return self

func get_neighbor (direction: HexDirection.HexDirections) -> HexCell:
	return neigbors[int(direction)]
	
#endregion
