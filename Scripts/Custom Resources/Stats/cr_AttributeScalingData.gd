extends Resource
class_name AttributeScalingData


@export_group("Attributes")
@export var STRScaling      : float = 0.0
@export var TEQScaling      : float = 0.0
@export var CONScaling      : float = 0.0
@export var INTScaling      : float = 0.0
@export var WILScaling      : float = 0.0
@export var CHAScaling      : float = 0.0
@export var FTHScaling      : float = 0.0
@export var LUKScaling      : float = 0.0

@export_group("Additional Attributes")
@export var addedAttributes : Dictionary


func scale(char_ref:Resource) -> float:
	var result = 0.0
	var _str = char_ref.get_att("Strength") * STRScaling
	var _teq = char_ref.get_att("Technique") * TEQScaling
	var _con = char_ref.get_att("Constitution") * CONScaling
	var _int = char_ref.get_att("Intelligence") * INTScaling
	var _wil = char_ref.get_att("Will") * WILScaling
	var _cha = char_ref.get_att("Charisma") * CHAScaling
	var _fth = char_ref.get_att("Will") * FTHScaling
	var _luk = char_ref.get_att("Charisma") * LUKScaling
	
	var add = get_additional_att_values(char_ref)
	
	result = _str + _teq + _con + _int + _wil + _cha + _fth + _luk + add
	return result


func get_additional_att_values(char_ref:Resource) -> float:
	var result = 0.0
	
	if !addedAttributes.is_empty():
		for aa in addedAttributes:
			var att = char_ref.get_att(aa) * addedAttributes[aa]
			result += att
		
	
	return result

