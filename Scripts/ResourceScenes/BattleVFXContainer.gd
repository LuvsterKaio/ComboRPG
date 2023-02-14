extends "res://Scripts/ResourceScenes/VFXContainer.gd"


# DATA
var operator : Object = null
var command : BattleCommand = null 
var hits_delivered : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func execute_hit() -> void:
	pass


func execute_all_hits() -> void:
	pass


func end_vfx() -> void:
	if !hits_delivered:
		execute_all_hits()
	call_deferred("queue_free")
	pass


func _on_animation_finished(anim_name):
	end_vfx()
	pass # Replace with function body.
