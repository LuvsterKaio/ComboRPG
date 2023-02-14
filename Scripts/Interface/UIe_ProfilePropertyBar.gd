extends Control



# SIGNALS


# REFERENCES
@onready var bar_current        : ProgressBar = get_node("Current")
@onready var bar_recoil         : ProgressBar = get_node("Recoil")
@onready var label_currentvalue : Object = get_node("CurrentValue")
@onready var label_maxvalue     : Object = get_node("MaxValue")


# EXPORTS
@export var att_name : String = "Health"
@export var maxatt_name : String = "Health"
@export var signal_name : String = "health_altered"

@export_group("Update")
@export var current_baseupdate_rate : float = 2.0  # COMPARED WITH HEALTH PERCENTAGE
@export var current_rise_rate : float = 1  # RISING MOD
@export var current_fall_rate : float = 0.01  # FALLING MOD

@export_group("Recoil")
@export var update_with_recoil : bool = true
@export var recoil_baseupdate_rate : float = 2.0  # COMPARED WITH HEALTH PERCENTAGE
@export var recoil_rise_rate : float = 0.01  # RISING MOD
@export var recoil_fall_rate : float = 1.0  # FALLING MOD

@export_group("Number")
@export var update_with_number : bool = true
@export var number_baseupdate_rate : float = 1.5  # COMPARED WITH HEALTH PERCENTAGE
@export var number_rise_rate : float = 1.0  # RISING MOD
@export var number_fall_rate : float = 1.0  # FALLING MOD



# DATA
var actor_profile      : ActorProfile
var character_baseAtts : CharacterAtt

var current_value : float = 100
var max_value     : float = 100

var current_text  : float = 100

var current_tween : Tween = null
var recoil_tween  : Tween = null
var number_tween  : Tween = null


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	
	if current_text != current_value:
		label_currentvalue.text = str(round(current_text))
	
	pass




func install_bar(_actor_profile:ActorProfile) -> void:
	
	var char_cur_atts    = _actor_profile.attribute_data
	var char_max_att     = char_cur_atts.get_att(maxatt_name)[0]
	var char_current_att = _actor_profile.get(att_name)
	
	character_baseAtts = char_cur_atts
	actor_profile = _actor_profile
	actor_profile.connect(signal_name, attribute_updated)
	
	current_value = char_current_att
	max_value = char_max_att
	current_text = current_value
	
	bar_current.value = current_value
	bar_current.max_value = max_value
	label_currentvalue.text = str(current_value)
	label_maxvalue.text = str(max_value)
	
	bar_recoil.value = current_value
	bar_recoil.max_value = max_value
	
	
	pass


func attribute_updated() -> void:
	
	var val = actor_profile.get_attribute(att_name)
	if val != current_value:
		update_values(val)
	
	pass


func update_values(new_value) -> void:
	
	var diff = abs(current_value - new_value)/max_value
	var update_time = current_baseupdate_rate*diff
	var recoil_time = recoil_baseupdate_rate*diff
	var number_time = number_baseupdate_rate*diff
	
	if current_tween == null:
		current_tween = create_tween()
	if recoil_tween == null:
		recoil_tween = create_tween()
	if number_tween == null:
		number_tween = create_tween()
	
	if new_value > current_value:
		var cur_update_time = update_time*current_rise_rate
		var rec_update_time = recoil_time*recoil_rise_rate
		var num_update_time = number_time*number_rise_rate
		
		current_tween.tween_property(bar_current, "value", new_value, cur_update_time)
		recoil_tween.tween_property(bar_recoil, "value", new_value, rec_update_time)
		number_tween.tween_property(self, "current_text", new_value, num_update_time)
		
	elif new_value < current_value:
		var cur_update_time = update_time*current_fall_rate
		var rec_update_time = recoil_time*recoil_fall_rate
		var num_update_time = number_time*number_fall_rate
		
		current_tween.tween_property(bar_current, "value", new_value, cur_update_time)
		recoil_tween.tween_property(bar_recoil, "value", new_value, rec_update_time)
		number_tween.tween_property(self, "current_text", new_value, num_update_time)
	
	pass








