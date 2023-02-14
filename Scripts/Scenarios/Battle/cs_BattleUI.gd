extends Control


# SIGNALs


# REFERENCEs
@onready var profiles : Control = get_node("Elements/Profiles")

# EXPORTs


# DATA


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func initialize(core:Node) -> void:
	
	var allied_char : Array = core.character_core.get_character_list("Allied")
	var enemy_char : Array = core.character_core.get_character_list("Foe")
	var all_characters : Array = core.character_core.get_all_characters()
	profiles.initialize_profiles(allied_char)
	pass




