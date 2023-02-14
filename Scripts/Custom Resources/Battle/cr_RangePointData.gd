extends Resource
class_name RangePointData



@export var hit_area : Vector2 = Vector2(300, 280)
@export var crit_area : Vector2 = Vector2(70, 64)
@export var super_area : Vector2 = Vector2(6, 4)

@export var hit_mod   : float = 1.0
@export var crit_mod  : float = 1.5
@export var super_mod : float = 1.8


# METHODS

func get_random_hit_area() -> float:
	return randf_range(hit_area.x, hit_area.y)

func get_random_crit_area() -> float:
	return randf_range(crit_area.x, crit_area.y)

func get_random_super_area() -> float:
	return randf_range(super_area.x, super_area.y)

func get_point_mod(type:String="Hit") -> float:
	
	if type == "Hit":
		return hit_mod
	elif type == "Crit":
		return crit_mod
	elif type == "Super":
		return super_mod
	else:
		return 1.0
	pass

