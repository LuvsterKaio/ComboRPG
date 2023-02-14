extends Control


# SIGNALs


# REFERNECEs
@onready var button : BaseButton = get_node("Title")
@onready var animator : AnimationPlayer = get_node("Animator")
@onready var battle_ui : Control = get_node("%BattleUI")

# EXPORTS
@export var key_relation : String = "Q"
@export var press_cooldown : float = 0.1


# DATA
var opened : bool = false
var locked : bool = false
var press_cd : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("%BattleUI").phase1_options.push_back(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if visible and !opened:
		if event.as_text() == key_relation:
			if !event.is_pressed():
				press()
			
		
	


func press() -> void:
	if !locked and !press_cd:
		
		var tmr = get_tree().create_timer(press_cooldown)
		tmr.connect("timeout", Callable(self, "on_cooldown_timer_end"))
		press_cd = true
		opened = true
		
		animator.stop(true)
		animator.play("Expand")
		battle_ui.change_phase(2)
	
	pass


func on_cooldown_timer_end():
	press_cooldown = false






