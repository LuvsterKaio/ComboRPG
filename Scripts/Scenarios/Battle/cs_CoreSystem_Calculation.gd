extends Node


# SIGNAL


# REFERENCEs


# EXPORTs
@export var initiative_variance : Vector2 = Vector2(0.9, 1.1)

# DATA




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func get_attribute_average(att_name:String, character_list:Array) -> int:
	var result = 0
	var sum = 0
	var count = 0
	
	for ca in character_list:
		var value = ca.get_current_att(att_name)
		sum += value
		count += 1
	
	result = sum / count
	
	return result


func get_average_initiative(character_list:Array) -> int:
	var result = 0
	var sum = 0
	var count = 0
	
	for ca in character_list:
		var value = ca.calculate_initiative()
		sum += value
		count += 1
	
	result = sum / count
	
	return result


func calculate_initiative_coefficient(average:int, actor_profile:ActorProfile) -> float:
	var result = 1.0
	
	var init = actor_profile.calculate_initiative(initiative_variance)
	var coefficient = float(init) / float(average)
	result = coefficient - 1.0
	
	return result






