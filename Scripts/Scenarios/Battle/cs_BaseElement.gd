extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func get_actor_startpoints() -> Array:
	return [get_node("ActorPositions/AlliedStartpoint"), get_node("ActorPositions/FoeStartpoint")]

func get_camera_pod() -> Node3D:
	var result = get_node("CameraPod")
	return result
