extends Resource
class_name BlockCalculationData


@export_group("Defense")
@export var DefenseScaling  : AttributeScalingData = null


@export_group("Piercing")
@export var BasePiercing      : float = 0.0
@export var ElementalPiercing : float = 0.0


func get_defense_value(char_ref:Resource, skill_ref:SkillData) -> float:
	var result = 0.0
	var piercing = max(1.0 - BasePiercing, 0.0)
	var elem_piercing = max(1.0 - ElementalPiercing, 0.0)
	
	var def = DefenseScaling.scale(char_ref)
	var new_def = def * piercing
	
	
	return result

