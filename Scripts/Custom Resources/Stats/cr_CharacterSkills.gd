extends Resource
class_name CharacterSkills



@export_group("Group Configuration")
@export var group_names     : Array[String] = []
@export var group_sizeLimit : Array[int] = []
@export var skill_injection : Array[SkillData] = []

@export_group("Skill List")
var skill_list           : Array = []
var equipped_skills      : Array = [] 
var skill_list_per_group : Dictionary = {}
var skills_equipped_per_group : Dictionary = {}
var skills_slots_available : Dictionary = {}



func setup_skillProfile(equip_all_injected:bool = true) -> void:
	var count = 0
	for gn in group_names:
		skill_list_per_group[gn] = []
		skills_equipped_per_group[gn] = []
		skills_slots_available[gn] = group_sizeLimit[count]
		count += 1
	
	for ij in skill_injection:
		
		if !skill_list.has(ij):
			skill_list.append(ij)
			if equip_all_injected:
				equip_skill(ij)
			
		
	
	pass


func is_skill_equippable(skill:SkillData) -> bool:
	var result = true
	
	var group = skill.skillGroup
	if group_names.has(group):
		if skills_slots_available[group] > 0:
			pass
		else:
			result = false
	else:
		result = false
	
	return result


func is_skill_equipped(skill:SkillData) -> bool:
	var result = false
	
	var group = skill.skillGroup
	if equipped_skills.has(skill):
		if skills_equipped_per_group[group].has(skill):
			result = true
	
	return result


func equip_skill(skill:SkillData) -> void:
	var group = skill.skillGroup
	var can_equip = is_skill_equippable(skill)
	
	if can_equip:
		if !skill_list.has(skill):
			skill_list.append(skill)
		if !equipped_skills.has(skill):
			equipped_skills.append(skill)
			if !skills_equipped_per_group[group].has(skill):
				skills_equipped_per_group[group].append(skill)
				skills_slots_available[group] -= 1
			
		
	
	pass


func add_skill(skill:SkillData) -> void:
	var group = skill.skillGroup
	
	if !skill_list.has(skill):
		skill_list.append(skill)
	if !skill_list_per_group[group].has(skill):
		skill_list_per_group[group].append(skill)
	
	pass


func get_group(group_name:String, only_equip:bool=false) -> Array:
	var result = []
	
	if only_equip:
		result = skills_equipped_per_group[group_name]
	else:
		result = skill_list_per_group[group_name]
	
	return result


func get_group_list() -> Array:
	var result = []
	
	for sg in skills_equipped_per_group:
		if !sg.is_empty():
			result.append(sg)
		
	
	return result









