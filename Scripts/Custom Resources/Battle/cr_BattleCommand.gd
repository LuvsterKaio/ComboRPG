extends Resource
class_name BattleCommand


# ENUM
enum TARGETTYPE { single, random, all }
enum TARGETSIDE { allied, enemy, all}


# EXPORTs


# DATA
var operator : Object = null
var cores : Dictionary = {}
var user : ActorProfile = null

var target_type : TARGETTYPE = TARGETTYPE
var target_list : Array = []

var target_side : TARGETSIDE = TARGETSIDE

	# SKILL DATA
var skill_used : SkillData = null
var hits_onhold : Array = []

	# USEFUL DATA
var stats_spent : Dictionary = {"AP" : 0, "HP" : 0, "EP" : 0, "OD" : 0, "Stress" : 0}
var target_data : Dictionary = {"Type" : TARGETTYPE, "Side" : TARGETSIDE}
var command_sequencer_icon : Control = null


func setup_command(_operator:Object, _user:ActorProfile, _skill:SkillData, _targets:Array) -> void:
	
	operator = _operator
	cores = _operator.get_operators()
	
	user = _user
	skill_used = _skill
	target_list = _targets
	
	# CREATE HITS
	
	
	pass


func get_stat_spent(stat_name:String) -> int:
	return stats_spent[stat_name]


