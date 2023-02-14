extends Control


# SIGNALs


# REFERENCEs
	# INSIDE
@onready var button     : TextureButton = get_node("Button")
@onready var cost       : Label = get_node("Cost")
@onready var actioncost : Label = get_node("ActionCost")
@onready var skill_icon : Control = get_node("SkillIcon")

	# OUTSIDE
var skill_group  : String = "Normals"
var skill_folder : Control = null
var skill_menu   : BaseBMNode = null
var origin  : Node = null


# EXPORTs
@export var can_call_info : bool = false


# DATA
var character_info : ActorProfile = null
var cost_list : Dictionary = {"AP" : 50, "EP" : 0}

var info_box : Control = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func setup_skillbutton(skill_info:SkillData) -> void:
	
	# ICON and FRAME
	var sk_icon = skill_info.skillIcon
	skill_icon.get_node("Icon").texture = sk_icon
	var sk_frame = get_node("/root/Prime").get_group(skill_info.skillFramegroup)
	skill_icon.get_node("Frame").texture = sk_frame
	var sk_gradient = skill_info.skillGradient
	skill_icon.get_node("Frame").material.set_shader_parameter("Gradient", sk_gradient)
	
	# COSTs
	cost_list = {"AP" : 50, "EP" : 0}
	
	pass


func call_info() -> void:
	
	
	
	pass



