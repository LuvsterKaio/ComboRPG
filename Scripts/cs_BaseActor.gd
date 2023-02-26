extends Node3D
class_name BattleActor


# SIGNALs


# REFERNCEs
@onready var main_image : Node3D = get_node("Base/Image")
@onready var effect_anchor : Node3D = get_node("Base/EffectAnchor")
@onready var character_mat : Material = get_node("Base/Image").material_override
var operator : Node = null


# EXPORTs
@export_group("EFFECTS")
@export var default_flash_curve : Curve = null

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
		
	

	# EFFECTS
		# COLOR FLASH
var flash_tween    : Tween = null
var flash_progress : float = 0.0
var flash_color    : Color = Color.WHITE
var flash_curve    : Curve = null
var flash_texture  : Texture = null
var flashing       : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if flashing:
		process_flash()
	pass



# DEFINITION FUNCTIONS

func set_side() -> void:
	var allied = character_profile.character_allied
	var _main_image : Node3D = get_node("Base/Image")
	_main_image.flip_h = !allied
	
	pass

func get_side() -> bool:
	return character_profile.character_allied

func setup_character_data(cprofile:Object) -> void:
	character_profile = cprofile
	pass


# VFX FUNCTIONS and AUXILIATORIES

func call_flash(color:Color, duration:float, scroll_texture:Texture = null, curve:Curve = default_flash_curve) -> void:
	
	flashing = true
	
	if flash_tween != null:
		if flash_tween.is_running():
			flash_tween.kill()
		flash_tween.tween_property(self, "flash_progress", 1.0, duration)
		
	else:
		flash_tween = create_tween().bind_node(self)
		flash_tween.tween_property(self, "flash_progress", 1.0, duration)
		flash_tween.connect("finished", reset_flash)
	
	flash_color = color
	flash_texture = scroll_texture
	flash_curve = curve
	
	pass

func process_flash() -> void:
	
	var intensity = flash_curve.sample(flash_progress)
	var fcolor = flash_color
	fcolor.a = intensity
	character_mat.set_shader_param("Color Overlay", fcolor)
	
	pass

func reset_flash() -> void:
	
	flashing = false
	flash_color = Color.WHITE
	flash_curve = null
	flash_texture = null
	flash_progress = 0.0
	pass



# POSITIONAL FUNCTIONS

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

func get_effect_anchor() -> Node3D:
	return effect_anchor



