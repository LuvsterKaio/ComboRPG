extends Node3D
class_name BattleActor


# SIGNALs


# REFERNCEs
var operator : Node = null
@onready var main_image : AnimatedSprite3D = get_node("Base/Image")

# EXPORTs


# DATA
	# CHARACTER DATA
var character_profile : Object = null


	# POSITIONING
var original_pos : Vector3 = Vector3.ZERO
var pos_tween : Tween
var pos_dynamics : Array = [] :
	get:
		return pos_dynamics
	set(new_value):
		if new_value != pos_dynamics and !new_value.is_empty():
			position_dynamics(new_value)
			pos_dynamics = new_value
		
	



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func set_side() -> void:
	var allied = character_profile.character_allied
	var _main_image : AnimatedSprite3D = get_node("Base/Image")
	_main_image.flip_h = !allied
	
	pass

func get_side() -> bool:
	return character_profile.character_allied


func setup_character_data(cprofile:Object) -> void:
	character_profile = cprofile
	pass


func position_dynamics(pos_values:Array) -> void:
	
	var new_pos = pos_values[0]
	var time = pos_values[1]
	
	if pos_tween != null:
		pos_tween.stop()
		pos_tween.tween_property(self, "position", new_pos, time)
		
	else:
		pos_tween = create_tween()
		pos_tween.tween_property(self, "position", new_pos, time)
	
	pos_tween.play()
	pos_tween.connect("finished", reset_pos_dynamics)
	
	pass


func return_to_original_position(time:float) -> void:
	pos_dynamics = [original_pos, time]

func reset_pos_dynamics() -> void:
	pos_dynamics = []
	pos_tween.disconnect("finished", reset_pos_dynamics)




