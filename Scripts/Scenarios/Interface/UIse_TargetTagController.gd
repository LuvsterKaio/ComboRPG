extends Control


# SIGNALs


# REFERENCEs
@onready var filter    : Control = get_node("Filter")
@onready var list      : VBoxContainer = get_node("Filter/List")
@onready var target    : TextureRect = get_node("Target")
@onready var animator  : AnimationPlayer = get_node("Animator")
@onready var clue      : Control = get_node("Clue")
@onready var clue_up   : Control = get_node("Clue/UpKey")
@onready var clue_down : Control = get_node("Clue/DownKey")
var battlecore    : Node = null
var charactercore : Node = null
var origin : Node = null


# EXPORTs
@export var targettag : PackedScene = null
@export var step_size : float = 42.0
@export var step_tolerance : int = 2
@export var scrollspeed : float = 0.3
@export var scrollup_command   : String = "ui_up"
@export var scrolldown_command : String = "ui_down"


# DATA
var activated      : bool = false

var current_tag    : Control = null
var current_char   : ActorProfile = null
var current_step   : int = 0
var current_scroll : float = 0.0

var tag_list       : Array = []
var target_tween   : Tween = null

var list_offset : Vector2 = Vector2()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_list()
	target_tween = create_tween().bind_node(self)
	list_offset = list.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func clear_list() -> void:
	
	for ci in list.get_children():
		ci.queue_free()
	
	pass


func show_targetindex(_true:bool = true) -> void:
	if _true:
		animator.play("Open")
		await animator.animation_finished
		activated = true
	else:
		animator.play_backwards("Open")
		activated = false
	pass



# TAG LIST FUNCTION

func setup_targets(character_list:Array) -> void:
	
	# SET CHARACTER LIST
	for tt in character_list:
		var tag = add_targettag(tt)
		tag_list.append(tag)
		pass
	
	# SET DEFAULT TARGET
	await get_tree().physics_frame
	move_within_list(0)
	
	pass


func add_targettag(actor_profile:ActorProfile) -> Object:
	var result = targettag.instantiate()
	list.add_child(result)
	result.controller = self
	result.origin = origin
	result.name = "Tag_" + actor_profile.profile_name
	result.setup_targettag(actor_profile)
	return result


func reorganize_list(character_list:Array) -> void:
	
	var _list = tag_list
	if character_list != null:
		_list = character_list
	
	var count = 0
	for rl in _list:
		list.move_child(rl, count)
		count += 1
	
	pass



# TAG LIST MANIPULATION


func move_within_list(_step:int = 1) -> void:
	
	current_step += _step
	var tl_size = tag_list.size()
	if current_step >= tl_size:
		current_step = 0
	elif current_step < 0:
		current_step = tl_size-1
	
	var ctag = tag_list[current_step]
	current_tag = ctag
	current_char = ctag.character_data
	ctag.select(true)
	
	scroll_list(current_step)
	
	pass


func move_to_tag(tag:Control) -> void:
	
	if tag_list.has(tag):
		
		var tag_index = tag_list.find(tag)
		var new_step = tag_index - current_step
		move_within_list(new_step)
		
	
	pass


func scroll_list(new_pos:int) -> void:
	
	var new_scroll = max(new_pos - step_tolerance, 0)*step_size
	var old_scroll = current_scroll
	current_scroll = new_scroll
	var old_scroll_pos = list_offset+Vector2(0, old_scroll)
	var new_scroll_pos = list_offset+Vector2(0, current_scroll)
	
	if old_scroll_pos != new_scroll_pos:
		var tweener : PropertyTweener = target_tween.tween_property(list, "position", new_scroll_pos, scrollspeed)
		tweener.from(old_scroll_pos)
	
	pass


func _input(event):
	
	if activated:
		# UP
		if event.is_action_pressed(scrollup_command):
			# VISUAL
			clue_up.get_node("Back").visible = true
			clue_up.get_node("Key").self_modulate = Color.DIM_GRAY
			clue_up.get_node("Arrow").self_modulate = Color.DIM_GRAY
		elif event.is_action_released(scrollup_command):
			# VISUAL
			clue_up.get_node("Back").visible = false
			clue_up.get_node("Key").self_modulate = Color.WHITE
			clue_up.get_node("Arrow").self_modulate = Color.WHITE
			move_within_list(-1)
		
		# DOWN
		if event.is_action_pressed(scrolldown_command):
			# VISUAL
			clue_down.get_node("Back").visible = true
			clue_down.get_node("Key").self_modulate = Color.DIM_GRAY
			clue_down.get_node("Arrow").self_modulate = Color.DIM_GRAY
		elif event.is_action_released(scrolldown_command):
			# VISUAL
			clue_down.get_node("Back").visible = false
			clue_down.get_node("Key").self_modulate = Color.WHITE
			clue_down.get_node("Arrow").self_modulate = Color.WHITE
			move_within_list(1)
		
	pass


func untoggle_all() -> void:
	
	for t in tag_list:
		if t.expanded:
			t.expand(false)
		pass
	
	pass



# TARGET AIM FUNCTIONS

func set_target(tag:Control) -> void:
	var pos = tag.get_target_point()
	var t_offset : Vector2 = target.pivot_offset
	var new_pos = pos - t_offset
	target.global_position = new_pos
	animator.play("Target")





