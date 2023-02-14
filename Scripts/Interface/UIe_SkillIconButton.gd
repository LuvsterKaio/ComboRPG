extends Control


# REFERNECES
@onready var skillIcon : Control = get_node("SkillIcon")
@onready var button : BaseButton = get_node("Button")
@onready var animator : AnimationPlayer = get_node("Animator")


# EXPORTS
@export var key_relation : String = "Q"
@export var press_cooldown : float = 0.1


# DATA
var locked : bool = false
var press_cd : bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() != null:
		get_node("%BattleUI").phase2_options.push_back(self)
		
		var button_icon = get_node("/root/Prime").key_dictionary[key_relation]
		get_node("Key").texture = button_icon
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if visible:
		if event.as_text() == key_relation:
			if !event.is_pressed():
				press()
			
		
	


func press() -> void:
	if !locked and !press_cd:
		
		var tmr = get_tree().create_timer(press_cooldown)
		tmr.connect("timeout", Callable(self, "on_cooldown_timer_end"))
		press_cd = true
		
		animator.stop(true)
		animator.play("Push")
	pass


func _on_button_button_up():
	press()
	pass # Replace with function body.


func on_cooldown_timer_end():
	press_cd = false

