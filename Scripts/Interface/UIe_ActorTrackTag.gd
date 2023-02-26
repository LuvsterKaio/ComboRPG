extends Node2D


# SIGNAL


# REFERENCEs
@onready var character_icon : TextureRect = get_node("Back/CharacterIcon")
@onready var animator : AnimationPlayer = get_node("Animator")
@onready var actionvalue : Label = get_node("Back/ActionValue")
var tracker : Control = null

# EXPORTs
@export var sideset_alliedcolor : Color = Color.DEEP_SKY_BLUE
@export var sideset_enemycolor  : Color = Color.DARK_RED

# DATA
	# Basis
var updating : bool = true

	# Actor
var actor_profile : ActorProfile = null
var actor_name : String = ""

	# Tracks
var track_pos  : float = 0.0
var main_track : Panel = null
var main_track_limits : Vector2 = Vector2(0, 0)
var back_track : Panel = null
var back_track_limits : Vector2 = Vector2(0, 0)
var current_track : Panel = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass



func _input(event) -> void:
	if event.is_action_pressed("i_alt"):
		actionvalue.visible = true
	elif event.is_action_released("i_alt"):
		actionvalue.visible = false
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
		
		set_track_higher_limits(max_act)
		set_track_lower_limits(act)
		
		act_profile.connect("action_altered", update)
		update()
		
		# INITIATE
		current_track = main_track
		if play_anim:
			animator.play("Initiate")
		
		# NAME ADDITIVE
		if name_add != "":
			var ci = get_node("CharacterIndex")
			ci.text = name_add
			ci.visible = true
			
		
		# SIDE SET COLOR
		if actor_profile.character_allied:
			get_node("Back").self_modulate = sideset_alliedcolor
			actionvalue.self_modulate = Color.ROYAL_BLUE
		else:
			get_node("Back").self_modulate = sideset_enemycolor
			actionvalue.self_modulate = Color.RED
		
		
	
	pass


func update() -> void:
	var new_value = actor_profile._get_current_action()
	var _max = actor_profile.get_max_action()
	var pos = 0.0
	
	if new_value >= 0:
		if current_track != main_track:
			current_track = main_track
		pos = new_value / main_track_limits.y
	
	else:
		if current_track != back_track:
			current_track == back_track
			set_track_lower_limits(new_value)
		pos = abs(new_value) / abs(back_track_limits.x)
		
	
	run_over_tracks(pos)
	
	track_pos = new_value
	actionvalue.text = str(round(new_value))
	
	pass


func run_over_tracks(new_pos:float) -> void:
	var y_pos = tracker.get_track_pos(current_track, new_pos)
	var pos = Vector2(0, y_pos)
	position = pos
	pass


func set_track_higher_limits(max_value:float) -> void:
	
	if main_track_limits.y != max_value:
		main_track_limits.y = max_value
	
	pass


func set_track_lower_limits(current_value:float) -> void:
	
	if back_track_limits.x > current_value:
		back_track_limits.x = current_value
	
	pass


func goal_reached() -> void:
	animator.play("Goal")
	updating = false
	pass

func restart() -> void:
	updating = true
	update()


func get_owner_and_tag() -> Array:
	var result = ["Name", null]
	
	result[0] = actor_name
	result[1] = self
	
	return result



