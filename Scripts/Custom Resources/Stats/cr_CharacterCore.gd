extends Resource
class_name CharacterCore


@export_group("Definitives")
@export var characterName : String = "Default"
@export var characterIsUnique : bool = false
@export var characterObject : PackedScene = null
@export var characterIcon : Texture = null
@export var characterIconTag : Texture = null


@export_group("Level and Experience")
@export var characterLevel : int = 1
@export var characterCurrentEXP : int = 0 :
	get:
		return characterCurrentEXP
	set(value):
		var oldvalue = characterCurrentEXP
		var diff = value - oldvalue
		if value >= characterNeededEXP:
			characterCurrentEXP = value - characterNeededEXP
		else:
			characterCurrentEXP = value
		characterTotalEXP += diff

var characterNeededEXP : int = 100
var characterTotalEXP  : int = 50
var characterEXProute  : EXPRoute = null


@export_group("Skills")
@export var characterSkills : CharacterSkills = null

@export_group("Equipments")
@export var characterEquips : CharacterSkills = null

@export_group("Attributes")
@export var characterBaseAttributes : CharacterAtt = null
@export var usesEquipment : bool = false
var characterEquipmentAttributes : Resource = null

var durable_attributes    : Dictionary = {}
var durable_statusEffects : Array = []



func get_character_attributes() -> Resource:
	var result = null
	if characterEquipmentAttributes != null:
		result = characterEquipmentAttributes
	else:
		result = characterBaseAttributes
	
	result.original_character_core = self
	
	return result


func set_durable_attributes(actor_profile:ActorProfile) -> void:
	
	durable_attributes["Health"] = actor_profile.get_att("Health")
	durable_attributes["Energy"] = actor_profile.get_att("Energy")


func get_durable_attribute(att_name:String):
	var result
	if durable_attributes.has(att_name):
		result = durable_attributes[att_name]
	else:
		result = null
	return result


func set_durable_statusEffects(se_list:Array) -> void:
	
	durable_statusEffects = durable_statusEffects + se_list


func install_durable_atts(actor_profile:ActorProfile, install_att:bool = true, install_se:bool = true) -> void:
	
	if install_att:
		actor_profile.set_health(durable_attributes["Health"])
		actor_profile.set_energy(durable_attributes["Energy"])
	
	if install_se:
		#actor_profile.
		pass
	



