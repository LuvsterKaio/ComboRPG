extends Node3D


# SIGNALs


# REFERENCEs
@onready var positions = get_node("Positions")


# EXPORTs
@export var party_data : PartyData = null

# DATA



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func get_point_position(index:int) -> Vector3:
	var object = get_node_or_null("Positions/" + str(index))
	var result = null
	if object != null:
		result = object.global_position
	return result


func get_character(index:int) -> CharacterCore:
	return party_data.get_char(index)


func get_character_and_position(index:int, partydata:PartyData = party_data) -> Array:
	var result = [null, Vector3(0, 0, 0)]
	
	var pos = get_point_position(index)
	var char = null
	if partydata != null:
		char = partydata.get_char(index)
	else:
		char = party_data.get_char(index)
	
	result[0] = char
	result[1] = pos
	
	return result



