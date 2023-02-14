extends Node2D


# SIGNAL


# REFERENCEs
@onready var character_icon : TextureRect = get_node("Back/CharacterIcon")
@onready var animator : AnimationPlayer = get_node("Animator")
var track : Control = null

# EXPORTs
@export var sideset_alliedcolor : Color = Color.DEEP_SKY_BLUE
@export var sideset_enemycolor  : Color = Color.DARK_RED

# DATA
	# Actor
var actor_profile : ActorProfile = null
var actor_name : String = ""

	# Tracks
var updating : bool = true

var current_track : String = "Track"
var main_track : Control = null
var value_limits : Vector2 = Vector2(0.0, 100.0)
var back_track : Control = null
var backvalue_limits : Vector2 = Vector2(-10.0, 0.0)



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
		
		value_limits = Vector2(0.0, max_act)
		run_over_track(act)
		
		actor_profile.connect("action_altered", update)
		
		
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
		
		# ANIMATION
		if play_anim:
			animator.play("Initiate")
		
	
	
	pass


func set_track_limits(track:String, _floor:float = 0.0, _ceiling:float = 100.0) -> void:
	match track:
		"Track":
			value_limits = Vector2(_floor, _ceiling)
		"BackTrack":
			backvalue_limits = Vector2(_floor, _ceiling)
		
	


func update() -> void:
	
	if updating:
		var act = actor_profile._get_current_action()
		if act < 0:
			current_track = "BackTrack"
			var _floor = backvalue_limits.x
			if _floor < act:
				set_track_limits("BackTrack", act, 0)
		else:
			current_track = "Track"
		
		run_over_track(act)
		
	pass


func interpolate_track(track:String, value:float) -> float:
	var result = 0.0
	
	match track:
		"Track":
			result = value / value_limits.y
		"BackTrack":
			result = value / backvalue_limits.y
		
	
	return result


func run_over_track(value:float) -> void:
	value = min(value, value_limits.y)
	match current_track:
		"Track":
			var gp = main_track.global_position
			var tracklimits = Vector2(gp.y + main_track.size.y, gp.y)
			var it = interpolate_track(current_track, value)
			global_position = Vector2(gp.x, lerp(tracklimits.x, tracklimits.y, it))
		"BackTrack":
			var gp = back_track.global_position
			var tracklimits = Vector2(gp.y + back_track.size.y, gp.y)
			var it = interpolate_track(current_track, value)
			global_position = Vector2(gp.x, lerp(tracklimits.x, tracklimits.y, it))
		
	
	pass


func get_owner_and_tag() -> Array:
	var result = ["Name", null]
	
	result[0] = actor_name
	result[1] = self
	
	return result


func reinitiate() -> void:
	updating = true
	update()


func goal_reached() -> void:
	updating = false
	animator.play("Goal")
	



