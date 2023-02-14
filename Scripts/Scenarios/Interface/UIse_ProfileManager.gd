extends Control


# SIGNALs
signal profile_position_reset()
signal profiles_ready()


# REFERENCEs
@onready var allied_layer : Control = get_node("Allied")

# EXPORTs
@export var profile_object : PackedScene = null
@export var move_speed : float = 0.4

# DATA
var profiles : Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	clear_profiles()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func initialize_profiles(allied_character:Array) -> void:
	
	setup_allied_profiles(allied_character, true)
	
	await get_tree().process_frame
	
	reset_profile_positions(true, true, 0.2)
	
	await profile_position_reset
	emit_signal("profiles_ready")


func setup_allied_profiles(character_list:Array, initiate_hidden:bool = false) -> void:
	
	for c in character_list:
		var inst = profile_object.instantiate()
		allied_layer.call_deferred("add_child", inst)
		inst.call_deferred("setup_profile", c)
		profiles.append(inst)
		if initiate_hidden:
			inst.call_deferred("set_virtual_position", Vector2(-250, 6))
		
	
	pass


func reset_profile_positions(tween:bool = false, force_open:bool = false, step_time:float = 0.2) -> void:
	
	for rp in profiles:
		if tween:
			rp.move_virtual(Vector2.ZERO, move_speed, false)
		else:
			rp.set_virtual_position(Vector2.ZERO, move_speed, false)
		
		if force_open:
			rp.hide_profile(false)
		
		if profiles.size() > 1:
			if step_time > 0:
				var tmr = get_tree().create_timer(step_time)
				await tmr.timeout
			
		
	
	emit_signal("profile_position_reset")
	
	pass


func clear_profiles(allied:bool = true, enemy:bool = true) -> void:
	profiles.clear()
	if allied:
		var allied_profiles : Array = allied_layer.get_children()
		if !allied_profiles.is_empty():
			for c in allied_profiles:
				c.queue_free()
			
		
	if enemy:
		pass
	
	pass


