extends Resource
class_name DamageCalculationData


@export_group("Damage")
@export var BaseDamage      : float = 10
@export var DamageVariation : Vector2 = Vector2(0.8, 1.1)
@export var DamageScaling   : AttributeScalingData = null


@export_group("Critical")
@export var BaseCriticalMod : float = 1.5


@export_group("Hit")
@export var HitVariation  : Vector2 = Vector2(0.8, 1.1)
@export var HitChance     : float = 55
@export var CritHitBonus  : float = 20



func get_damage(char_ref:Resource, skill_ref:SkillData) -> float:
	var result = 0.0
	
	var scaling = DamageScaling.scale(char_ref)
	var var_mod = randf_range(DamageVariation.x, DamageVariation.y)
	
	var elem_mod = char_ref.get_element_mod(skill_ref.get_elements)
	
	result = ((BaseDamage + scaling) * elem_mod) * var_mod
	
	return result


func get_hitchance(char_ref:Resource, hit_type:String) -> float:
	var result = 0.0
	
	var char_cunning = char_ref.get_att("Cunning")
	var hit_chance = HitChance
	var hit_var = randf_range(HitVariation.x, HitVariation.y)
	
	if hit_type == "Crit":
		hit_chance += CritHitBonus
	
	result = ((char_cunning*2) + hit_chance) * hit_var
	
	return result


