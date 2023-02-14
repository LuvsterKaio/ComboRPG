extends SkillAction



@export_group("Action Definitions")
@export var skillDamageCalculation  : DamageCalculationData = null
@export var skillBlockCalculation   : BlockCalculationData = null
@export var skillHitNumber          : Vector2 = Vector2(1, 1)
@export var skillHitRangeData       : RangePointData = null
@export var skillBlockRangeData     : Resource = null


# FUNCTIONS

func execute_action(battle_state:Resource, operator:Object) -> void:
	
	
	
	pass


