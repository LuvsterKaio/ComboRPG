extends Control


# SIGNAL


# REFERENCEs
@onready var ornament : TextureRect = get_node("Back/Ornaments")
@onready var nameLabel : Label = get_node("Name")
@onready var icon : TextureRect = get_node("Icon")
@onready var button : Button = get_node("Button")


# EXPORTs


# DATA
var menu_core : Control = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func activate() -> void:
	pass


func hide_button(_true:bool = true) -> void:
	button.visible = _true
	pass


func _on_button_up():
	activate()
	pass # Replace with function body.
