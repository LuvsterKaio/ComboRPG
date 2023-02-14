extends Resource
class_name PartyData

@export var party_characters : Array[CharacterCore]

func get_char(index:int) -> CharacterCore:
	return party_characters[index]

