extends Control


# SIGNALs
signal target_character(character:ActorProfile)


# REFERENCEs
@onready var animator  : AnimationPlayer = get_node("Animator")
@onready var back      : Panel = get_node("Base/Back")
@onready var namelabel : Label = get_node("Base/Name")
@onready var addLabel  : Label = get_node("Base/AddName")
@onready var button    : Button = get_node("Base/Button")
@onready var charIcon  : TextureRect = get_node("Base/CharacterIcon")
var controller : Control = null
var origin : Node = null


# EXPORTs
@export var allied_color  : Color = Color.BLUE
@export var enemy_color   : Color = Color.RED
@export var target_offset : Vector2 = Vector2(-20, 21)


# DATA
var character_data : ActorProfile = null
var expanded : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func setup_targettag(actor_profile:ActorProfile) -> void:
	
	character_data = actor_profile
	actor_profile.link_interface_element("TargetTag", self)
	
	# BACK
	if character_data.character_allied:
		back.self_modulate = allied_color
	else:
		back.self_modulate = enemy_color
	
	# NAME
	namelabel.text = character_data.character_core.characterName
	if character_data.profile_name_add != "":
		addLabel.visible = true
		addLabel.text = character_data.profile_name_add
	
	# ICON
	charIcon.texture = character_data.character_core.characterIconTag
	
	
	pass


func select(_true:bool = true) -> void:
	
	if _true:
		# UNTOGGLE OTHER TARGETTAGS
		controller.untoggle_all()
		
		# ANIMATE # TOGGLE THIS TARGETTAG
		expand(true)
		call_targetpoint(self)
		# CHANGE CURRENT TARGET IN BATTLE CORE
		controller.battlecore.current_target = character_data
		
	else:
		expand(false)
	
	pass


func expand(_true:bool = true) -> void:
	if _true:
		if !expanded:
			animator.play("Expand")
			expanded = true
	else:
		if expanded:
			animator.play("Contract")
			expanded = false
		
	pass


func call_targetpoint(targettag:Control = self) -> void:
	controller.set_target(targettag)
	pass


func get_target_point() -> Vector2:
	var base_pos = global_position
	return base_pos+target_offset


func _on_button_up():
	if Input.is_action_just_released("i_leftclick"):
		if !expanded:
			controller.move_to_tag(self)
		
	elif Input.is_action_just_released("i_rightclick"):
		pass
	
	
	pass # Replace with function body.






