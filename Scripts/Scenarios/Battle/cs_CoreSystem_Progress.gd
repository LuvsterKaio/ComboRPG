extends Node


# ENUM


# SIGNALs
signal phase_objectives_met(objectiveList:Array)
signal characters_entered_the_scene


# REFERENCEs
	# Core
@onready var characterCore : Node = get_node("%CharacterCore")
@onready var calculationCore : Node = get_node("%CalculationCore")

	# UI
@onready var turntrack : Control = get_parent().get_node("UILayer/UI/BattleUI/Elements/TurnTrack")
@onready var profiles  : Control = get_parent().get_node("UILayer/UI/BattleUI/Elements/Profiles")

	# Timer
@onready var timer : Timer = get_node("Timer")

# EXPORTs
@export var progress_time_scale : float = 1.0

@export_group("Recover Step")
@export var ap_per_second : float = 15
@export var initiative_base : float = 0.5
@export var inititate_percentage_range : Vector2 = Vector2(0.25, 0.80)

# DATA
	# OUT OF TURN
var initiated : bool = false
var ready_characters : Array = []
var current_turnowner : ActorProfile = null
var is_turnowner_cpu : bool = false


	# WITHIN TURN
var current_stage : String = "Null"
var current_phase : int = 0
var attack_engaged : bool = false

var phase_objectives : Dictionary = {}



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	turn_machine()
	pass


func initiate() -> void:
	progress("Initial", 0, 0.1)
	pass


func turn_machine() -> void:
	
	if timer.is_stopped():
		match current_stage:
			"Null":
				pass
			"Initial":
				initial_phase()
				pass
			"Turn Start":
				turnstart_phase()
				pass
			"Action":
				pass
			"CPUAction":
				pass
			"Recover":
				recover_phase()
				pass
			
		
	
	pass


func progress(stage:String, phase:int, time:float = 0.0) -> void:
	
	if stage != "":
		current_stage = stage
	if phase >= 0:
		current_phase = phase
	if time > 0.0:
		timer.start(time)
	
	pass

func check_progress() -> Dictionary:
	var result = {"Stage" : current_stage, "Phase" : current_phase}
	return result



	# PHASE OBJECTIVES

func set_phase_objective(objectiveName:String) -> void:
	if !phase_objectives.has(objectiveName):
		phase_objectives[objectiveName] = false

func complete_phase_objective(objectiveName:String) -> void:
	if phase_objectives.has(objectiveName):
		phase_objectives[objectiveName] = true
		var done : bool = check_objectives()
		if done:
			var objectives_met = erase_objectives()
			emit_signal("phase_objectives_met", objectives_met)
		
	pass

func check_objectives() -> bool:
	var result = true
	if !phase_objectives.is_empty():
		for co in phase_objectives:
			if !phase_objectives[co]:
				result = false
				break
			
		
	
	return result


func erase_objectives() -> Array:
	var keys = phase_objectives.keys()
	phase_objectives = {}
	return keys


# TURN PHASE FUNCTIONS

func turnstart_phase() -> void:
	match current_phase:
		0:
			if !ready_characters.is_empty():
				var char = null
				if !ready_characters.size() > 1:
					char = get_character_most_ready(ready_characters)
				else:
					char = ready_characters.front()
				
				if char != null:
					var tag = char.get_linked_interfaceelement("ActorTag")
					tag.goal_reached()
					if char.character_allied:
						pass
					else:
						pass
					
				
			else:
				progress("Recover", 0, 0.2)
		
	
	pass

func get_character_most_ready(character_list:Array) -> ActorProfile:
	var result = null
	var highest_init = -99999
	
	for ci in character_list:
		var init = ci.calculate_initiative()
		if init > highest_init:
			highest_init = init
			result = ci
		
	
	return result


func initiate_turn_as_character(actor_profile:ActorProfile, is_cpu:bool = false) -> void:
	
	is_turnowner_cpu = is_cpu
	current_turnowner = actor_profile
	
	pass


func process_turn(actor_profile:ActorProfile) -> void:
	
	
	pass


func process_machineTurn(actor_profile:ActorProfile) -> void:
	
	
	pass




# RECOVER PHASE FUNCTIONS

func recover_phase() -> void:
	match current_phase:
		0:
			var char_list = characterCore.get_all_characters()
			recovering(char_list) 
			
		1:
			progress("Turn", 0, 0.0)


func recovering(character_list:Array) -> void:
	
	var base_ap = ap_per_second/60.0
	
	for ca in character_list:
		var act_regen = ca.get_current_att("ActionRegen")[0]
		var base_regen = ca.get_max_action() / 100.0
		var rap = base_regen + act_regen
		var recover_value = base_ap*rap
		var done = recover_action(ca, recover_value)
		if done:
			ready_characters.append(ca)
			if check_progress()["Stage"] == "Recover":
				progress("", 1, 0.01)
		pass
	
	pass


func recover_action(actor:ActorProfile, value:float) -> bool:
	var done = false
	
	actor.alter_ap(value)
	if actor.is_action_max():
		done = true
	
	return done


# INITIAL PHASE FUNCTIONS


func initial_phase() -> void:
	
	match current_phase:
		0:
			set_phase_objective("Set Profiles")
			set_phase_objective("Set Initiative")
			set_phase_objective("Characters Moved")
			
			progress("", 1, 0.2)
		
		1: 
			initiate_battle()
			progress("", 2, 0)
		
		2:
			await phase_objectives_met
			if check_objectives():
				progress("Turn", 0, 1.0)
	
	pass


func initiate_battle() -> void:
	
	# SET FLOATING EFFECTS
	###
	
	# MOVE CHARACTERS TO SCENE
	var allied_cs = characterCore.get_character_list("Allied")
	var enemy_cs = characterCore.get_character_list("Foe")
	move_characters_to_scene(allied_cs, enemy_cs)
	
	complete_phase_objective("Characters Moved")
	await get_tree().create_timer(0.5).timeout
	
	# PROFILES
	profiles.initialize_profiles(allied_cs)
	
	complete_phase_objective("Set Profiles")
	await get_tree().create_timer(0.2).timeout
	
	# INITIATIVES
	turntrack.open_element(true)
	var characters = characterCore.get_all_characters()
	declare_initiative(characters)
	
	complete_phase_objective("Set Initiative")
	
	
	pass


func declare_initiative(character_list:Array) -> void:
	
	# Get Average Initiative
	var average_init = calculationCore.get_average_initiative(character_list)
	
	
	turntrack.clear_tags()
	# Set Initial Action Points
	for ca in character_list:
		var act = ca.get_max_action()
		var coe = calculationCore.calculate_initiative_coefficient(average_init, ca)
		var bas = act*initiative_base
		var pos = bas
		
		# GET START COORDINATE
		if coe > 0.0:
			var new_coe = abs(coe)
			pos = lerp(bas, act*inititate_percentage_range.y, new_coe)
		elif coe < 0.0:
			var new_coe = abs(coe)
			pos = lerp(bas, act*inititate_percentage_range.x, new_coe)
		elif coe == 0.0:
			pos = initiative_base
		
		var perc_pos = float(pos) / 100.0
		ca.set_ap(pos, true)
		
		# CREATE ACTOR TAG ON LOCATION
		turntrack.add_tag(ca)
		await get_tree().create_timer(0.2).timeout
		
	
	pass


func move_characters_to_scene(allied_characters:Array, enemy_characters:Array) -> void:
	
	# ALLIES
	for mc in allied_characters:
		var actor_scene = mc.actor_scene
		actor_scene.return_to_original_position(0.4)
		
		var ind_timer = get_tree().create_timer(0.1, true, true)
		await ind_timer.timeout
		
	
	var grp_timer = get_tree().create_timer(0.25, true, true)
	await grp_timer.timeout
	
	
	# ENEMIES
	for mc in enemy_characters:
		var actor_scene = mc.actor_scene
		actor_scene.return_to_original_position(0.4)
		
		var ind_timer = get_tree().create_timer(0.1, true, true)
		await ind_timer.timeout
		
	
	emit_signal("characters_entered_the_scene")
	
	pass





