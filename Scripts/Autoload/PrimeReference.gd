extends Node



var key_dictionary : Dictionary = {
	"Q" : preload("res://Assets/Icons/Keys/KeyIcon_Q.png"),
	"W" : preload("res://Assets/Icons/Keys/KeyIcon_W.png"),
	"E" : preload("res://Assets/Icons/Keys/KeyIcon_E.png"),
	"A" : preload("res://Assets/Icons/Keys/KeyIcon_A.png"),
	"S" : preload("res://Assets/Icons/Keys/KeyIcon_S.png"),
	"D" : preload("res://Assets/Icons/Keys/KeyIcon_D.png")
}

var group_skillframes : Dictionary = {
	"Groupless" : preload("res://Assets/Icons/Skills/Frames/SkillFrame_Hexa_f00.png"),
	"Weapon Attack" : preload("res://Assets/Icons/Skills/Frames/SkillFrame_Hexa_s01.png"),
	"Divine Skills" : preload("res://Assets/Icons/Skills/Frames/SkillFrame_Hexa_s02.png")
}

var skillgroup_icons : Dictionary = {
	"Weapon Techniques" : preload("res://Assets/Icons/Skills/Segments/icon_SkillSeg_Weapon0.png"),
	
}

var alphabet : Array = ["A", "B", "C", "D", "E", "G", "H", "I", "J"]



# USEFUL INFORMATION


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func get_skillframe(groupname:String = "Groupless") -> Texture:
	var result = null
	
	if group_skillframes.has(groupname):
		result = group_skillframes[groupname]
	else:
		result = "Groupless"
	
	return result


func get_skillgroup_icon(groupname:String) -> Texture:
	var result = null
	
	if skillgroup_icons.has(groupname):
		result = skillgroup_icons[groupname]
	
	return result


