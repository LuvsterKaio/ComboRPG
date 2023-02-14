extends Resource
class_name CharacterAtt


signal health_altered

# ATTRIBUTES
@export_group("Health")
@export var cHealth             : int = 100
@export var cHealthRegen        : float = 0.0
@export var cHealthStressDamage : float = 0.1
@export var cHealthStressDamageGrowthRate : float = 0.08


@export_group("Energy")
@export var cEnergy               : int = 50
@export var cEnergyRegen          : float = 0.0
@export var cEnergyOverdrive      : float = 50
@export var cEnergyStressDamage   : float = 0.1
@export var cEnergyStressDamageGrowthRate : float = 0.05


@export_group("Action")
@export var cAction             : float = 100
@export var cActionRegen        : float = 0.0
@export var cActionDamageResist : float = 0.0

@export_group("Base Attributes")

@export var cStrength       : int = 6
@export var cTechnique      : int = 6
@export var cConstitution   : int = 6
@export var cIntelligence   : int = 6
@export var cWill           : int = 6
@export var cCharisma       : int = 6
@export var cFaith          : int = 6
@export var cLuck           : int = 6

@export_group("Stress Attributes")
@export var cStressLimit      : int = 100
@export var cStressResistance : int = 0
@export var cStressMultiplier : float = 0.0

# APTITUDEs
@export_group("Aptitudes")
@export var cInitiative     : int = 0
@export var cInvestigation  : int = 0
@export var cStudy          : int = 0
@export var cTemperace      : int = 0
@export var cThievery       : int = 0



# BATTLE STATs
@export_group("Battle Attributes")
@export var cCritChance                  : float = 0.0
@export var cCritDamage                  : float = 0.0
@export var cBaseElementalResistance     : float = 0.0
@export var cBaseStatusResistance        : float = 0.0


# ELEMENTAL STATs
@export_group("Elemental Attributes")
@export var cNeutralResist               : float = 0.0
@export var cNeutralMultiplier           : float = 0.0
@export var cMetaphysicalResist          : float = 0.0
@export var cMetaphysicalMultiplier      : float = 0.0
@export_subgroup("Physical")
@export var cSlashingResist              : float = 0.0
@export var cSlashingMultiplier          : float = 0.0
@export var cPunctureResist              : float = 0.0
@export var cPunctureMultiplier          : float = 0.0
@export var cBluntResist                 : float = 0.0
@export var cBluntMultiplier             : float = 0.0
@export_subgroup("Elemental")
@export var cFlameResist                 : float = 0.0
@export var cFlameMultiplier             : float = 0.0
@export var cColdResist                  : float = 0.0
@export var cColdMultiplier              : float = 0.0
@export var cElectricResist              : float = 0.0
@export var cElectricMultiplier          : float = 0.0


# USEFUL DATA
var original_values : Dictionary
var max_values : Dictionary
var get_max_values : Array = ["Health", "Overdrive", "Energy", "Action"]
var original_character_core : CharacterCore = null



# FUNCTIONS

func get_att(att_name:String) -> Array:
	var result = [0, "Name"]
	
	var att = get("c"+att_name)
	var original_value = get_original_att(att_name)
	result = [att, att_name, original_value]
	
	return result


func get_original_att(att_name:String):
	var result
	if original_values.has(att_name):
		result = original_values[att_name]
	else:
		result = get("c"+att_name)


func set_att(att_name:String, new_value) -> void:
	if !original_values.has(att_name):
		original_values[att_name] = get("c"+att_name)
	set("c"+att_name, new_value)


func reset_att(att_name:String) -> void:
	if original_values.has(att_name):
		var original_value = original_values[att_name]
		set("c"+att_name, original_value)


func get_element_mod(element_list:Array) -> float:
	var result = 1.0
	
	for ea in element_list:
		var value = get_att("c"+ea+"Resist")
		result *= value
	
	return result


func set_max_values(character_att:CharacterAtt) -> void:
	
	for gmv in get_max_values:
		var max_value = character_att.get_att(gmv)
		max_values[gmv] = gmv
	
	pass


func is_maxxed(att_name:String, current_value, change_to_max:bool = false) -> bool:
	var result = false
	var value = current_value
	var max = get_att(att_name)[1]
	
	if value != max:
		if change_to_max:
			set_att(att_name, max)
		
	else:
		result = true
	
	return result



func signal_change() -> void:
	
	emit_signal("changed")
	pass



# ATTRIBUTE CALCULATIONS












