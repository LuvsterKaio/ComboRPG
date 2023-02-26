extends Control


# SIGNALs


# REFERENCEs
	# INSIDE
@onready var button     : TextureButton = get_node("SkillIcon/Button")
@onready var actioncost : Label = get_node("ActionCost")
@onready var skill_icon : Control = get_node("SkillIcon")
@onready var animator   : AnimationPlayer = get_node("Animator")

	# OUTSIDE
var sequencer : Control = null
var battle_core : Node = null
var origin  : Node = null


# EXPORTs
@export var can_call_info : bool = false


# DATA
var character_info : ActorProfile = null
var skill_index    : int = 0
var ap_cost : int = 0.0

var info_box : Control = null




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func setup_commandbutton(command:BattleCommand) -> void:
	
	# COMMAND
	command.command_sequencer_icon = self
	
	# ICON and FRAME
	var sk = command.skill_used
	var sk_icon = sk.skillIcon
	skill_icon.get_node("Icon").texture = sk_icon
	var sk_frame = get_node("/root/Prime").get_group(sk.skillFramegroup)
	skill_icon.get_node("Frame").texture = sk_frame
	var sk_gradient = sk.skillGradient
	skill_icon.get_node("Frame").material.set_shader_parameter("Gradient", sk_gradient)
	
	# COSTs
	ap_cost = command.stats_spent["AP"]
	actioncost.text = str(ap_cost)
	
	pass


func call_animator(anim_name:String) -> void:
	animator.play(anim_name)


func remove_itself() -> void:
	battle_core
	pass


func _on_button_up():
	remove_itself()
	pass # Replace with function body.
