extends Node3D


# SIGNALs


# REFERENCEs
@onready var camera : Camera3D = get_node("Camera3D")

# EXPORTs
@export var movement_speed : float = 1.0
@export var time_per_unit : float = 0.2
@export var forced_anchor : Vector2 = Vector2.ZERO
@export var shake_decay : float = 0.25

# DATA
var anchor : Vector2 = Vector2.ZERO
var mov_tween : Tween = null
var shake : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchor(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if shake > 0:
		shaking()
	pass


# POSITIONING and SHAKING FUNCTIONS

func find_object_in_screen(obj:Object) -> Vector2:
	var result : Vector2 = Vector2.ZERO
	var obj_pos = obj.position
	
	result = camera.unproject_position(obj_pos)
	
	return result


func add_shake(shake_value:float) -> void:
	if shake <= 0.0:
		shake = shake_value
	elif shake_value / 2 > shake:
		shake = shake_value
	elif shake_value / 2 <= shake:
		shake += shake_value/2
	elif shake >= shake_value:
		shake += 1.0
	pass


func shaking() -> void:
	if shake > 0:
		var shake_vec : Vector2 = Vector2(randf_range(shake, -shake), randf_range(shake, -shake))
		shake = max(shake - shake_decay, 0.0)
		camera.h_offset = shake_vec.x
		camera.v_offset = shake_vec.y


# MOVEMENT FUNCTIONS


func get_bidimensional_pos(global:bool = false) -> Vector2:
	if global:
		return Vector2(global_position.x, global_position.y)
	else:
		return Vector2(position.x, position.y)


func set_anchor(go_to_anchor:bool = false) -> void:
	
	if forced_anchor != Vector2.ZERO:
		anchor = forced_anchor
	else:
		anchor = get_bidimensional_pos(true)
	
	if go_to_anchor:
		move_to(anchor, 1.0, false)
	
	pass



func move_to(target_pos:Vector2, speed_scale:float = 1.0, use_tween:bool = true) -> void:
	var tpos = target_pos
	
	if mov_tween != null:
		if mov_tween.is_running():
			mov_tween.stop()
		
	if use_tween:
		var total_travel = abs(target_pos.x) + abs(target_pos.y)
		var time = ((total_travel*time_per_unit)/movement_speed)/speed_scale
		var v3pos = Vector3(tpos.x, tpos.y, global_position.z)
		mov_tween = create_tween()
		var tweener = mov_tween.tween_property(self, "global_position", v3pos, time)
		tweener.set_trans(Tween.TRANS_CUBIC)
		tweener.set_ease(Tween.EASE_IN_OUT)
	else:
		global_position = Vector3(tpos.x, tpos.y, global_position.z)
	
	pass


func move_interpolation(target_pos:Vector2, use_anchor:bool = true, interpolation:float = 0.5) -> void:
	var new_vec = Vector3.ZERO
	var base_pos = get_bidimensional_pos(true)
	if use_anchor:
		base_pos = anchor
	
	var new_x = lerp(base_pos.x, target_pos.x, interpolation)
	var new_y = lerp(base_pos.y, target_pos.y, interpolation)
	
	new_vec = Vector2(new_x, new_y)
	move_to(new_vec)
	
	pass


func return_to_anchor(speed_scale:float = 1.0) -> void:
	
	var v2_pos = get_bidimensional_pos(true)
	if v2_pos != anchor:
		move_to(anchor, speed_scale)
	
	pass


