extends Control


# SIGNALs


# REFERENCEs
@onready var skill_list    : GridContainer = get_node("List")
@onready var folder_name   : Label = get_node("Name")
@onready var expand_button : Button = get_node("Expand")
@onready var expand_icon   : TextureRect = get_node("ExpandIcon")
@onready var folder_icon   : TextureRect = get_node("Icon")
var menu_node : BaseBMNode = null
var origin : Node = null


# EXPORTs
@export var skill_option       : PackedScene = null
@export var expand_extra_space : float = 10


# DATA
var expanded : bool = false
	# CHARACTER
var character_linked : ActorProfile = null
var list_name : String = ""

	# SIZE
var expand_height : float = 132
var hide_height   : float = 28
var expand_tween  : Tween = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func setup_skillfolder(actor_profile:ActorProfile, segment_name:String) -> void:
	
	if actor_profile != character_linked:
		clear_list()
	
	character_linked = actor_profile
	list_name = segment_name
	name = segment_name + "_" + actor_profile.profile_name
	
	# ICON
	var icon = get_node("/root/Prime").get_skillgroup_icon(segment_name)
	folder_icon.texture = icon
	
	# NAME
	folder_name.text = segment_name
	
	# FILL with SKILLs
	var skill_profile = actor_profile.get_skills
	var skills = skill_profile.skills_equipped_per_group
	var slist = skills[segment_name]
	
	for sg in slist:
		add_skillbutton(sg)
			
		
	
	# LAST TOUCHES
	reformulate_expand_height()
	
	pass


func add_skillbutton(skilldata:SkillData) -> void:
	
	var inst = skill_option.instantiate()
	skill_list.add_child(inst)
	inst.setup_skillbutton(skilldata)
	inst.skill_group = skilldata.skillGroup
	inst.skill_folder = self
	inst.skill_menu = menu_node
	inst.origin = origin
	
	pass


func expand_or_hide() -> void:
	
	if expanded:
		hide_folder()
		expanded = false 
	else:
		expand_folder()
		expanded = true
	
	pass


func expand_folder() -> void:
	
	if !expanded:
		if expand_tween == null:
			expand_tween = create_tween()
		if expand_tween.is_running():
			expand_tween.stop()
		
		# TWEEN ICON
		var it = expand_tween.tween_property(expand_icon, "scale", Vector2(1.0, -1.0), 0.25)
		it.set_ease(Tween.EASE_IN_OUT)
		
		# TWEEN FOLDER
		reformulate_expand_height()
		var ft = expand_tween.tween_property(self, "custom_minimum_size", Vector2(0, expand_height), 0.25)
		ft.set_ease(Tween.EASE_IN_OUT)
		
	
	pass


func hide_folder() -> void:
	
	if expanded:
		if expand_tween == null:
			expand_tween = create_tween()
		if expand_tween.is_running():
			expand_tween.stop()
		
		# TWEEN ICON
		var it = expand_tween.tween_property(expand_icon, "scale", Vector2(1.0, 1.0), 0.25)
		it.set_ease(Tween.EASE_IN_OUT)
		
		# TWEEN FOLDER
		reformulate_expand_height()
		var ft = expand_tween.tween_property(self, "custom_minimum_size", Vector2(0, hide_height), 0.25)
		ft.set_ease(Tween.EASE_IN_OUT)
		
	
	pass


func reformulate_expand_height() -> void:
	var grid_height = skill_list.size.y
	var bttn_height = hide_height
	
	expand_height = grid_height + bttn_height + expand_extra_space
	
	pass


func clear_list() -> void:
	var list = skill_list.get_children()
	for ci in list:
		ci.queue_free()
	pass



func _on_expand_button_up():
	expand_or_hide()
	pass # Replace with function body.
