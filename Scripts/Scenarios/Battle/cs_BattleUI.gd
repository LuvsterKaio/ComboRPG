extends Control


# SIGNALs


# REFERENCEs
@onready var profiles    : Control = get_node("Elements/Profiles")
@onready var targetindex : Control = get_node("Elements/TargetIndex")

# EXPORTs


# DATA


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func initialize(core:Node) -> void:
	
	var allied_char : Array = core.character_core.get_character_list("Allied")
	var enemy_char : Array = core.character_core.get_character_list("Foe")
	var all_characters : Array = core.character_core.get_all_characters()
	var enemy_first : Array = enemy_char + allied_char
	profiles.initialize_profiles(allied_char)
	targetindex.setup_targets(enemy_first)
	pass




