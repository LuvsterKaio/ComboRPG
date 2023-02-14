extends Resource
class_name BattleCommand


# ENUM
enum TARGETTYPE { single, random, all }
enum TARGETSIDE { allied, enemy, all}


# EXPORTs


# DATA
var operator : Object = null
var cores : Dictionary = {}
var user : Object = null

var target_type : TARGETTYPE = TARGETTYPE
var target_list : Array = []

var target_side : TARGETSIDE = TARGETSIDE

	# SKILL DATA
var skill_used : SkillData = null
var hits_onhold : Array = []


func setup_command(_operator:Object, _user:ActorProfile, _skill:SkillData) -> void:
	
	operator = _operator
	cores = _operator.get_operators()
	
	user = _user
	
	pass

