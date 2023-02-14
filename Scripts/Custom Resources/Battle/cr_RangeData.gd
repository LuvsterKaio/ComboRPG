extends Resource
class_name RangeData


@export var points     : Array[RangePointData] = []
@export var points_pos : Array[Vector2] = []



func get_point_and_position(index:int = 0) -> Array:
	var point = get_point(index)
	var pos = get_point_position_by_index(index)
	return [point, pos]


func get_point(index:int=0) -> RangePointData:
	if points.size() > index:
		var p = points[index]
		return p
	else:
		return null
	pass


func get_point_position_by_index(index:int=0) -> float:
	if points_pos.size() > index:
		var point_vec = points_pos[index]
		var rand = randf_range(point_vec.x, point_vec.y)
		return rand
	else:
		return -100.0
	pass
