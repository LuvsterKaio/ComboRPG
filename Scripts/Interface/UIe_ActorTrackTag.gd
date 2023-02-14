extends Node2D


# SIGNAL


# REFERENCEs
@onready var character_icon : TextureRect = get_node("Back/CharacterIcon")

# EXPORTs
@export var sideset_alliedcolor : Color = Color.DEEP_SKY_BLUE
@export var sideset_enemycolor  : Color = Color.DARK_RED

# DATA
	# Actor
var actor_profile : ActorProfile = null
var actor_name : String = ""



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func setup_actortag(act_profile:ActorProfile, play_anim:bool = true) -> void:
	
	if act_profile != null:
		actor_profile = act_profile
	
	if actor_profile != null:
		# BASIC SETUP
		var char_icon = actor_profile.character_core.characterIconTag
		get_node("Back/CharacterIcon").texture = char_icon
		actor_name = actor_profile.profile_name
		var name_add = actor_profile.profile_name_add
		
		act_profile.link_interface_element("ActorTag", self)
		
		var act = actor_profile._get_current_action()
		var max_act = actor_profile.get_max_action()
		
		
		
		# NAME ADDITIVE
		if name_add != "":
			var ci = get_node("CharacterIndex")
			ci.text = name_add
			ci.visible = true
			
		
		# SIDE SET COLOR
		if actor_profile.character_allied:
			get_node("Back").self_modulate = sideset_alliedcolor
		else:
			get_node("Back").self_modulate = sideset_enemycolor
		
		
	
	pass



func get_owner_and_tag() -> Array:
	var result = ["Name", null]
	
	result[0] = actor_name
	result[1] = self
	
	return result




