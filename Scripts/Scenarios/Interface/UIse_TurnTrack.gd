extends Control



# SIGNALs


# REFERENCEs
@onready var tagtrack = get_node("Tags")
@onready var animator : AnimationPlayer = get_node("Animator")
@onready var maintrack : Control = get_node("Track")
@onready var backtrack : Control = get_node("BackTrack")


# EXPORTs
@export var actor_tag : PackedScene = null


# DATA
@export var element_opened : bool = false
var tags : Array = []
var low_limit : int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_tags()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func clear_tags() -> void:
	var list = tagtrack.get_children()
	for et in list:
		et.queue_free()
	pass


func open_element(open:bool = true) -> void:
	if open:
		animator.play("Open")
	else:
		animator.play("Hide")
	


func get_track(what_track:String = "Track") -> Control:
	var result = null
	match what_track:
		"Track":
			result = maintrack
		"BackTrack":
			result = backtrack
		
	
	return result


func set_new_low(new_value:int) -> void:
	if low_limit > new_value:
		low_limit = new_value
	pass


func get_track_pos(track:Control, pos:float = 0.0) -> float:
	var result = 0.0
	
	var t_top = track.position.y
	var t_bot = track.position.y + track.size.y
	
	result = lerp(t_bot, t_top, pos)
	
	return result


func add_tag(character:ActorProfile, play_anim:bool = true) -> void:
	
	var act_tag = actor_tag.instantiate()
	act_tag.tracker = self
	act_tag.main_track = maintrack
	act_tag.back_track = backtrack
	tagtrack.call_deferred("add_child", act_tag)
	await get_tree().process_frame
	act_tag.setup_actortag(character, play_anim)
	tags.append(act_tag)
	
	pass





