extends Resource
class_name SkillData



enum SKILLMODE {PASSIVE, ACTIVE}

# Illustratives

@export_group("Illustratives")

@export var skillName          : String = "Default"
@export var skillIcon          : Texture = null
@export var skillColor         : Color = Color.WHITE 
@export var skillGradient      : Gradient = null 
@export var skillFramegroup    : String = "Groupless"

@export var skillAnimationCall : Resource = null


# Definitives

@export_group("Definitives")
@export var skillModes            : SKILLMODE = 0
@export var skillElements         : Array = ["Neutral"]
@export var skillGroup            : String = "Weapon Technique"

# STATs

@export_group("Stats")
@export var skillActions : Array[SkillAction] = []
@export var skillEPCost     : int = 0
@export var skillAPCost     : int = 50
@export var skillHPCost     : float = 0.0
@export var skillStressCost : Vector2i = Vector2i(0, 0)



# EQUIPMENTAL

@export_group("Equipment")
@export var can_be_equipment : bool = false
@export var skillStatEquipData : Resource = null



func get_elements() -> Array:
	return skillElements

func get_costs_as_dictionary() -> Dictionary:
	var result = {}
	
	result["EP"] = skillEPCost
	result["AP"] = skillAPCost
	if skillStressCost.x > 0:
		result["Stress"] = skillStressCost
	if skillHPCost > 0:
		result["HP"] = skillHPCost
	
	return result








