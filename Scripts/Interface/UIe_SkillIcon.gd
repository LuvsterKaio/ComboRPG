extends Control


# REFERNECES
@onready var icon : TextureRect = get_node("Icon")


# EXPORTS



# DATA
var skill_data : SkillData



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func setup_skill_icon():
	var tex = skill_data.skillIcon
	icon.texture = tex
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#

