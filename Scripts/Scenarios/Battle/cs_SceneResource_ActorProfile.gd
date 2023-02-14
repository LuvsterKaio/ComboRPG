extends Node
class_name ActorProfile


# SIGNALs
signal turn_end()
signal turn_start()
signal death()
signal health_altered()
signal energy_altered()
signal stress_altered()
signal overdrive_altered()
signal action_altered()

# REFERENCEs
var interface_elements = {"ActorTag" : null}

# EXPORTs


# DATA
var profile_name  : String = "Default" 
var profile_name_add : String = ""
var character_core : Resource
var attribute_data : Resource
var actor_scene    : Object

var character_allied : bool = false

	# STATUS EFFECTS
var status_effects : Array

	# MUTABLE ATTS
var current_health       : float = 0 : set = _set_current_health, get = _get_current_health
var current_energy       : float = 0 : set = _set_current_energy, get = _get_current_energy
var current_actionPoints : float = 0 : set = _set_current_action, get = _get_current_action
var current_overdrive    : float = 0 : set = _set_current_overdrive, get = _get_current_overdrive
var current_stress       : float = 0 : set = _set_current_stress, get = _get_current_stress
var current_totalStess   : float = 0





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func setup_profile(ccore:Resource, operator:Object, initial_pos:Vector3, anchor:Vector3, allied:bool=true) -> void:
	
	# SET ATTRIBUTES
	character_core = ccore
	var original_cdata = character_core.get_character_attributes()
	attribute_data = original_cdata.duplicate()
	set_mutable_atts()
	character_allied = allied
	
	
	actor_scene = ccore.characterObject.instantiate()
	actor_scene.setup_character_data(self)
	actor_scene.set_side()
	operator.position_actor(actor_scene, initial_pos)
	actor_scene.original_pos = anchor
	actor_scene.operator = operator
	
	pass


func link_interface_element(elementName : String, element) -> void:
	interface_elements[elementName] = element

func get_linked_interfaceelement(elementName : String) -> Object:
	if interface_elements.has(elementName):
		return interface_elements[elementName]
	else:
		return null


func set_mutable_atts() -> void:
	
	# HEALTH
	var chp = character_core.get_durable_attribute("Health")
	if chp != null:
		current_health = chp
	else:
		current_health = get_current_att("Health")[0]
	
	# ENERGY
	var cep = character_core.get_durable_attribute("Energy")
	if cep != null:
		current_energy = cep
	else:
		current_energy = get_current_att("Energy")[0]
	
	# STRESS
	var cst = character_core.get_durable_attribute("Stress")
	if cst != null:
		current_stress = cst
	else:
		current_stress = 0
	
	# OVERDRIVE - Resets every battle
	# ACTION - Resets every battle
	
	
	pass


func get_core_name(name_list:Dictionary) -> String:
	var result = ""
	var additive = ""
	result = character_core.characterName
	if !character_core.characterIsUnique:
		if name_list.has(result):
			additive = get_node("/root/Prime").alphabet[name_list[result]]
			name_list[result] += 1
			result = result+" "+additive
		
		else:
			name_list[result] = 0
			additive = get_node("/root/Prime").alphabet[name_list[result]]
			name_list[result] += 1
			result = result+" "+additive
		
	
	profile_name_add = additive
	profile_name = result
	return result


func get_current_att(att_name:String):
	var result : Array
	
	result = attribute_data.get_att(att_name)
	return result


func set_current_att(att_name:String, new_value) -> void:
	attribute_data.set_att(att_name, new_value)


func get_skills() -> CharacterSkills:
	return character_core.characterSkills


# ALTER COMMON ATTRIBUTES

func get_attribute(att_name:String):
	var result = null
	
	match att_name:
		"Health":
			result = current_health
		"Energy":
			result = current_energy
		"Action":
			result = current_actionPoints
		"Stress":
			result = current_stress
		"Overdrive":
			result = current_overdrive
	
	return result

	# HEALTH

func _set_current_health(new_value:float) -> void:
	current_health = new_value
	emit_signal("health_altered")
	pass

func _get_current_health() -> float:
	return current_health

func set_hp(new_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Health")[0]
	var value = max(0, min(new_value, _max))
	current_health = value
	
	pass

func alter_hp(increment_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Health")[0]
	var value = current_health + increment_value
	value = max(0, min(value, _max))
	current_health = value
	
	pass


	# ENERGY


func _set_current_energy(new_value:float) -> void:
	current_energy = new_value
	emit_signal("energy_altered")
	pass

func _get_current_energy() -> float:
	return current_energy

func set_ep(new_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Energy")[0]
	var value = max(0, min(new_value, _max))
	current_energy = value

func alter_ep(increment_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Energy")[0]
	var value = current_energy + increment_value
	value = max(0, min(value, _max))
	current_energy = value
	
	pass


	# ACTION POINTS


func _set_current_action(new_value:float) -> void:
	current_actionPoints = new_value
	emit_signal("action_altered")
	pass

func _get_current_action() -> float:
	return current_actionPoints

func get_max_action() -> float:
	return get_current_att("Action")[0]

func is_action_max() -> bool:
	var result = false
	if current_actionPoints >= get_max_action():
		result = true
	return result

func get_action_in_track(track_pos:float) -> float:
	return get_current_att("Action")[0] * track_pos

func set_ap(new_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Action")[0]
	var value = min(new_value, _max)
	current_actionPoints = value

func alter_ap(increment_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Action")[0]
	var value = current_actionPoints + increment_value
	value = min(value, _max)
	current_actionPoints = value
	
	pass


	# STRESS


func _set_current_stress(new_value:float) -> void:
	var _old = current_stress
	var diff = current_stress - new_value
	current_stress = new_value
	current_totalStess += diff
	emit_signal("stress_altered")
	pass

func _get_current_stress() -> float:
	return current_stress

func set_stress(new_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Stress")[0]
	var value = max(0, min(new_value, _max))
	current_stress = value

func alter_stress(increment_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Stress")[0]
	var value = current_stress + increment_value
	value = max(0, min(value, _max))
	current_stress = value
	
	pass


	# OVERDRIVE


func _set_current_overdrive(new_value:float) -> void:
	current_overdrive = new_value
	emit_signal("overdrive_altered")
	pass

func _get_current_overdrive() -> float:
	return current_overdrive

func set_overdrive(new_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Overdrive")[0]
	var value = max(0, min(new_value, _max))
	current_overdrive = value

func alter_overdrive(increment_value:float, check_max:bool = true) -> void:
	var _max = 9999999
	if check_max:
		_max = get_current_att("Overdrive")[0]
	var value = current_overdrive + increment_value
	value = max(0, min(value, _max))
	current_overdrive = value
	
	pass



# CALCULATIONS

func calculate_initiative( variation:Vector2 = Vector2(0.9, 1.1) ) -> int:
	var result = 0
	
	var init = get_current_att("Initiative")[0]
	var teq = get_current_att("Technique")[0]
	
	
	result = int(round((float(init) + float(teq))*randf_range(variation.x, variation.y)))
	return result




