extends Node



# SIGNALs


# REFERENCEs
@onready var action_sequencer : Control = get_parent().get_node("UILayer/UI/BattleUI/Elements/ActionSequencer")
@onready var target_index : Control = get_parent().get_node("UILayer/UI/BattleUI/Elements/TargetIndex")

# EXPORTs
@export var arquive_space_per_character : int = 5
@export var arquive_space_per_cpu : int = 0

# DATA
	# Character
var current_character : ActorProfile = null
	# Auto Target
var current_target : ActorProfile = null
	# Sequences
var current_sequence   : SequenceData = null
var sequence_arquives  : Dictionary = {}
var on_sequence        : bool = false
var sequencer_shown    : bool = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_sequencer.battlecore = self
	target_index.battlecore = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


# SETUP FUNCTIONS

func character_turnstart(actor:ActorProfile) -> void:
	current_character = actor
	action_sequencer.setup_sequencer(actor)
	set_new_sequence()
	
	pass


func set_new_sequence() -> void:
	if current_character != null:
		current_sequence = SequenceData.new()
		current_sequence.character_owner = current_character
	pass


# SEQUENCER FUNCTIONS

func show_actionsequencer(open_low:bool = false) -> void:
	action_sequencer.open_sequencer()
	if open_low:
		action_sequencer.move_sequencer("Low", false)
	else:
		action_sequencer.move_sequencer("Center", false)
	sequencer_shown = true
	pass


func get_last_command() -> BattleCommand:
	var result = current_sequence.command_list.back()
	return result


func archive_sequence(sequence:SequenceData) -> void:
	var seq_char = sequence.character_owner
	var char_name = seq_char.profile_name
	
	var arquive_space = arquive_space_per_character
	if !seq_char.character_allied:
		arquive_space = arquive_space_per_cpu
	
	if arquive_space > 0:
		if !sequence_arquives.has(char_name):
			sequence_arquives[char_name] = []
		sequence_arquives[char_name].append(sequence)
		if sequence_arquives[char_name].size() > arquive_space:
			var fs = sequence_arquives[char_name].front()
			sequence_arquives[char_name].erase(fs) # REMOVE FIRST
		
	
	pass


func add_command_to_sequencer(command:BattleCommand) -> void:
	pass


func remove_command_from_sequencer(skill_data:BattleCommand) -> void:
	pass






