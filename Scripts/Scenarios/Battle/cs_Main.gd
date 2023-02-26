extends Node


# SIGNALs


# REFERENCEs
@onready var battle_core       : Node = get_node("BattleCore")
@onready var progress_core     : Node = get_node("%ProgressCore")
@onready var calculation_core  : Node = get_node("CalculationCore")
@onready var character_core    : Node = get_node("%CharacterCore")
@onready var battleUI          : Control = get_node("UILayer/UI/BattleUI")
@onready var battle_camera     : Node3D = get_node("Base/CameraPod")


# EXPORTs


# DATA



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	initiate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func initiate() -> void:
	character_core.initiate()
	progress_core.initiate()
	
	# UI
	
	pass


func get_object_position_on_screen(obj:Object) -> Vector2:
	return battle_camera.find_object_in_screen(obj)


func get_operators() -> Dictionary:
	var ops : Dictionary = { "Battle" : battle_core,
	"Progress" : progress_core, "Calculation" : calculation_core,
	"Character" : character_core }
	
	return ops



