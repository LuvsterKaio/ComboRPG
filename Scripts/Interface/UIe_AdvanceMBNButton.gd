extends Control


# SIGNAL
signal button_activated()


# REFERENCEs
@onready var menu : BaseBMNode = get_parent().get_parent()
@onready var ornament : TextureRect = get_node("Back/Ornaments")
@onready var nameLabel : Label = get_node("Name")
@onready var icon : TextureRect = get_node("Icon")
@onready var button : Button = get_node("Button")


# EXPORTs
@export var next_menu_name : String = "Default"

# DATA
var menu_core : Control = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func activate() -> void:
	menu.call_next_menu(next_menu_name)


func hide_button(_true:bool = true) -> void:
	button.visible = _true
	pass


func _on_button_up():
	activate()
	pass # Replace with function body.
