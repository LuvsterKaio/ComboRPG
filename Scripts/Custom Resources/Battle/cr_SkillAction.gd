extends Resource
class_name SkillAction



@export var targetData        : TargetData = null
@export var executionPriority : int = 0
@export var requirementData   : Resource = null

func execute_action(battle_state:Resource, operator:Object) -> void:
	
	pass

