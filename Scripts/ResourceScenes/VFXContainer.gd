extends Node3D




# REFERENCES
@onready var animator : AnimationPlayer = get_node("Animator")
@onready var base     : Node3D = get_node("Base")


# EXPORTS


# DATA
var combat_core : Node = null
@onready var vfx_elements : Array = base.get_children()


# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_vfx()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initiate_vfx():
	animator.play("Run")

