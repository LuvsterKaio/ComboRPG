extends Control
class_name BaseBMNode


# SIGNAL



# REFERENCE
@onready var animator : AnimationPlayer = get_node("Animator")
@onready var lock : Control = get_node("Lock")
@onready var link : Control = get_node("LinkPosition")
var controller : Control = null

# EXPORT
@export var anchor_position : Vector2 = Vector2(0, 0)

# DATA

var open_position   : Vector2 = Vector2(0, 0)

var character_focus : ActorProfile = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func setup_character(actor:ActorProfile) -> void:
	character_focus = actor
	pass


func unlock(_true:bool = true) -> void:
	lock.visible = !_true


func open(_true:bool = true) -> void:
	if _true:
		animator.play("Open")
	else:
		animator.play_backwards("Open")


func move_to_menu_link(other_menu:BaseBMNode, tween:bool = true, time:float = 0.4) -> void:
	var other_link = other_menu.link
	var new_pos = Vector2(other_link.position.x, anchor_position.y)
	var start_pos = Vector2(other_link.position.x, controller.open_position.y)
	
	if start_pos != position:
		position = start_pos
	
	if tween:
		var mov_tween = get_tree().create_tween()
		mov_tween.tween_property(self, "position", new_pos, time)
	else:
		position = new_pos
	
	
	pass


func move_to_menu_origin(tween:bool = true, time:float = 0.4) -> void:
	
	var new_pos = Vector2(0.0, anchor_position.y)
	var start_pos = Vector2(0.0, controller.open_position.y)
	
	if start_pos != position:
		position = start_pos
	
	if tween:
		var mov_tween = get_tree().create_tween()
		mov_tween.tween_property(self, "position", new_pos, time)
	else:
		position = new_pos
	
	
	pass


