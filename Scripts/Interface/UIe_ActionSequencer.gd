extends Control


# SIGNAL
signal add_preview(preview_skill:SkillData, preview_ap:int)
signal decay_preview()
signal expire_preview(preview_skill:SkillData)


# REFERENCEs
@onready var drum         : TextureRect = get_node("Drum")
@onready var drum_ring    : TextureRect = get_node("Drum/Ring")
@onready var animator     : AnimationPlayer = get_node("Animator")
@onready var bar_right    : ProgressBar = get_node("ActionBar/Current0")
@onready var bar_left     : ProgressBar = get_node("ActionBar/Current1")
@onready var command_list : HBoxContainer = get_node("SkillIcons/List")
var battlecore : Node = null


# EXPORTs
@export_group("SKILL ICONS")
@export var skill_icon : PackedScene = null
@export_group("POSITIONALS")
@export var center_pos   : Vector2 = Vector2(960, 619)
@export var low_pos : Vector2 = Vector2(960, 619)
@export_group("PREVIWING")
@export var preview_use_tween : bool = true
@export var preview_tween_duration : float = 0.2
@export var preview_expire_duration : float = 0.2
@export_group("DRUM & SPIN")
@export var spin : bool = true
@export var drumspin_speed : float = 0.1
@export var spintime_scale : float = 1.0
@export var altdrumspin : Curve = null


# DATA
	# Character
var character_profile : ActorProfile = null
var current_ap : float = 0.0
var max_ap : float = 100.0

	# Preview
var preview_skill : SkillData = null
var preview_value : int = 0
var preview_decay : bool = false

var sequencer_tween : Tween = null
var opened : bool = false
var current_spin : Curve = null
var spin_duration : float = 0
var local_spin_scale : float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clean_icons()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	spin_drum(_delta)
	pass



func setup_sequencer(character:ActorProfile) -> void:
	character_profile = character
	var cap : float = character._get_current_action()
	var map : float = character.get_max_action()
	setup_bars(cap, map)
	pass


func setup_bars(c_ap:float, max_ap:float) -> void:
	# RIGHT
	bar_right.value = c_ap
	bar_right.max_value = max_ap
	bar_right.get_node("Cost").max_value = max_ap
	bar_right.get_node("Cost").value = 0
	bar_right.get_node("Recoil").max_value = max_ap
	
	# LEFT
	bar_left.value = c_ap
	bar_left.max_value = max_ap
	bar_left.get_node("Cost").max_value = max_ap
	bar_left.get_node("Cost").value = 0
	bar_left.get_node("Recoil").max_value = max_ap
	
	pass


func place_preview(skill_preview:SkillData, preview_ap:int) -> void:
	
	preview_skill = skill_preview
	preview_value = preview_ap 
	set_preview_value(preview_value)
	
	pass


func end_preview(_skill_preview:SkillData) -> void:
	
	preview_skill = null
	preview_value = 0
	set_preview_value(0, true)
	
	pass


func set_preview_value(preview_value:int, no_duration:bool = false) -> void:
	var cost_r = bar_right.get_node("Cost")
	var cost_l = bar_left.get_node("Cost")
	
	if !no_duration:
		if preview_use_tween:
			var pween = create_tween().tween_property(cost_r, "value", preview_value, preview_tween_duration)
			pween.tween_property(cost_l, "value", preview_value, preview_tween_duration)
		else:
			cost_r.value = preview_value
			cost_l.value = preview_value
		
	else:
		cost_r.value = preview_value
		cost_l.value = preview_value
	
	pass


# SKILL ICON FUNCTIONS

func add_command_icon(command:SkillData) -> Object:
	var si_inst = skill_icon.instantiate()
	si_inst.setup_commandbutton(command)
	si_inst.sequencer = self
	si_inst.battle_core = battlecore
	si_inst.origin = battlecore
	place_command_icon(si_inst)
	
	return si_inst


func place_command_icon(command_icon_obj:Control) -> void:
	command_list.add_child(command_icon_obj)
	command_icon_obj.call_animator("Open")
	pass


func clean_icons() -> void:
	var list = command_list.get_children()
	for cl in list:
		cl.queue_free()


# ANIMATION FUNCTIONS

func open_sequencer(_true:bool = true) -> void:
	
	if _true:
		if !opened:
			animator.play("Open")
			opened = true
		
	else:
		if opened:
			animator.play_backwards("Open")
			opened = false
		
	
	pass


# POSITION FUNCTIONS

func move_sequencer(pos_name:String, tween:bool = false, time:float = 0.3):
	var pos = Vector2(0, 0)
	
	match pos_name:
		"Center":
			pos = center_pos
		"Low":
			pos = low_pos
		
	
	if tween:
		if sequencer_tween == null:
			sequencer_tween = create_tween()
		sequencer_tween.tween_property(self, "position", pos, time)
		sequencer_tween.set_trans(Tween.TRANS_CUBIC)
	
	pass


# SPIN FUNCTIONS

func spin_drum(_delta) -> void:
	
	if spin:
		var spin_var : float = 1.0 
		if current_spin != null:
			if spin_duration >= 1:
				spin_duration = 0
				current_spin = null
				local_spin_scale = 1.0
			else:
				spin_var = current_spin.sample(spin_duration)
				spin_duration += ((1.0*_delta)*spintime_scale)/local_spin_scale
				spin_duration = min(1.0, spin_duration)
			
		
		var drum_rot = drumspin_speed*spin_var
		drum.rotation += drum_rot
		drum_ring.rotation += (drum_rot*2.0)*-1.0
		
	
	pass


func add_spin(spin:Curve = null, spin_scale:float = 1.0) -> void:
	if spin == null:
		current_spin = altdrumspin
	else:
		current_spin = spin
	spin_duration = 0
	local_spin_scale = spin_scale


