extends Control


# REFERENCE
@onready var animator  : AnimationPlayer = get_node("Animator")
@onready var base      : Control = get_node("Base")
@onready var nameLabel : Label = get_node("Base/Name")
@onready var actorIcon : TextureRect = get_node("Base/Icon")
@onready var healthBar : Control = get_node("Base/Bars/HPBar")
@onready var energyBar : Control = get_node("Base/Bars/EPBar")
@onready var stressBar : Control = get_node("Base/Bars/StressBar")

# DATA
var actor_profile : ActorProfile = null
var virtual_move_tween : Tween = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	virtual_move_tween = get_tree().create_tween()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func hide_profile(_true:bool) -> void:
	if _true:
		animator.play("Hide")
	else:
		animator.play_backwards("Hide")


func setup_profile(new_profile:ActorProfile) -> void:
	
	if actor_profile != new_profile:
		actor_profile = new_profile
		nameLabel.text = actor_profile.profile_name
		#actorIcon.texture = actor_profile.character_core.characterIcon
		healthBar.install_bar(new_profile)
		energyBar.install_bar(new_profile)
		stressBar.install_bar(new_profile)
	
	pass


func set_virtual_position(new_pos:Vector2, global:bool = true) -> void:
	if virtual_move_tween.is_running():
		virtual_move_tween.stop()
	
	if global:
		base.global_position = new_pos
	else:
		base.position = new_pos
	
	pass


func move_virtual(new_pos:Vector2, time:float = 0.4, global:bool = true) -> void:
	if virtual_move_tween.is_running():
		virtual_move_tween.stop()
	
	if global:
		var new_tween = create_tween().tween_property(base, "global_position", new_pos, time)
		new_tween.set_ease(Tween.EASE_IN_OUT)
		new_tween.set_trans(Tween.TRANS_SINE)
	else:
		var new_tween = create_tween().tween_property(base, "position", new_pos, time)
		new_tween.set_ease(Tween.EASE_IN_OUT)
		new_tween.set_trans(Tween.TRANS_SINE)
	
	pass



