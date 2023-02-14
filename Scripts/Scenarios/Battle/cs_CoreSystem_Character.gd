extends Node


# SIGNALs


# REFERENCEs
@onready var base3D : Node3D = get_parent().get_node("Base")
@onready var actors : Node3D = get_parent().get_node("Base/Actors")
@onready var actor_positions : Node3D = get_parent().get_node("Base/ActorPositions")

# EXPORTs
@export_group("Party and Enemy")
@export var allied_partydata : PartyData = null
@export var allied_partycomp : PackedScene = preload("res://Scenes/ResourceScenes/PartyComps/Base_PartyComps.tscn")
@export var foe_partydata    : PartyData = null
@export var foe_partycomp    : PackedScene = null
@export_group("Debug")
@export var show_partycomps  : bool = false

# DATA
var blank_profile    : Object = preload("res://Scenes/ResourceScenes/CombatSceneResources/csr_ActorProfile.tscn")

	# CHARACTER LISTS
@export_group("Characters")
var characters          : Array
var characters_dead     : Array
var characters_allied   : Array
var characters_foe      : Array

var character_names     : Dictionary




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func initiate() -> void:
	setup_characters()
	pass


func setup_characters() -> void:
	
	# PARTYCOMPs
	var allied_pc = set_partycomp(allied_partycomp, true, allied_partydata) # ALLIED
	var foe_pc    = set_partycomp(foe_partycomp, false, foe_partydata)   # ENEMY
	
	await get_tree().physics_frame # PERIOD
	
	clear_profiles()
	
	execute_partycomp(allied_pc, true)
	execute_partycomp(foe_pc, false)
	
	if !show_partycomps:
		hide_partycomps()
	
	pass


func set_partycomp(partycomp:PackedScene, allied:bool, partydata:PartyData = null) -> Object:
	
	var place = actor_positions.get_node("Foes")
	if allied:
		place = actor_positions.get_node("Allies")
	
	var pc_inst = partycomp.instantiate()
	place.add_child(pc_inst)
	if partydata != null:
		pc_inst.party_data = partydata
	
	return pc_inst


func execute_partycomp(partycomp_scene:Object, allied:bool=true) -> void:
	
	var party = partycomp_scene.party_data
	var count = 0
	for ga in party.party_characters:
		var info = partycomp_scene.get_character_and_position(count)
		add_character(info[0], info[1], allied)
		count += 1
	
	pass


func add_character(ccore:CharacterCore, pos:Vector3, allied:bool) -> void:
	var new_profile = blank_profile.instantiate()
	
	var starting_pos = base3D.get_actor_startpoints()
	var stpos = Vector3.ZERO
	if allied:
		stpos = starting_pos[0].position
	else:
		stpos = starting_pos[1].position
	
	var initial_pos = Vector3(stpos.x, pos.y, pos.y)
	
	# LISTINGS
	characters.push_back(new_profile)
	if allied:
		characters_allied.append(new_profile)
		get_node("Allied").add_child(new_profile)
		
	else:
		characters_foe.append(new_profile)
		get_node("Enemy").add_child(new_profile)
		
	
	# NAMING
	new_profile.setup_profile(ccore, self, initial_pos, pos, allied)
	new_profile.name = new_profile.get_core_name(character_names)
	
	
	pass


func hide_partycomps() -> void:
	
	var list : Array = [actor_positions.get_node("Allies"), actor_positions.get_node("Foes")]
	
	for l in list:
		for l2 in l.get_children():
			l2.visible = false
		
		
	pass


func position_actor(actor_object:Object, pos:Vector3) -> void:
	var allied = actor_object.get_side()
	var place = actors.get_node("Allies")
	if !allied:
		place = actors.get_node("Foes")
	
	place.add_child(actor_object)
	actor_object.global_position = pos
	
	pass


func clear_profiles(only_enemies:bool = false) -> void:
	
	if !only_enemies:
		var allies = get_node("Allied")
		for a in allies.get_children():
			a.queue_free()
	
	
	var enemies = get_node("Enemy")
	for e in enemies.get_children():
		e.queue_free()
	
	pass


func get_character_list(list_name:String) -> Array:
	var result = []
	match list_name:
		"Allied":
			result = characters_allied
		"Foe":
			result = characters_foe
		"Dead":
			result = characters_dead
		
	
	return result


func get_all_characters(all_alive:bool = true) -> Array:
	var result = []
	
	var pool = characters
	if all_alive:
		for ia in pool:
			if !characters_dead.has(ia):
				result.append(ia)
			
		
	else:
		result = pool
	
	return result






