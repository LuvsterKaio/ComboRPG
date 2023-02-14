extends Resource
class_name EXPRoute


@export var base_exp : int = 100
@export var exp_curve : Curve = null
@export var base_exp_growth : float = 0.25


func get_level_exp(level:int, needed_exp:int) -> int:
	var result = 0
	
	if level > 1:
		
		var pos = float(level) / 100
		var value = exp_curve.sample(pos)
		var n_mod = value + base_exp_growth
		var new_nexp = needed_exp * (1 + n_mod)
		result = new_nexp
	
	else:
		result = base_exp
	
	
	return result




