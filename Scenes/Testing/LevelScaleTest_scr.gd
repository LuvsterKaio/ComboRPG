extends Control


@onready var results : Label = get_node("Results")

@export var level_scaling_data : Resource = null
@export var testing_scale : int = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	test_scaling()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func test_scaling() -> void:
	
	results.text = ""
	
	var count = testing_scale
	var level = 1
	var needed_exp = 0
	while count > 0:
		
		var lv = str(level)
		var scaling = level_scaling_data.get_level_exp(level, needed_exp)
		var result = lv + "   " + str(scaling)
		
		results.text += (result + "\n")
		
		needed_exp = scaling
		level += 1
		count -= 1
	
	
	pass
