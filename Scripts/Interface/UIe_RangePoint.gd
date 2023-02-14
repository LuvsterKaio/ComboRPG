extends Control


# SIGNAs


# REFERENCEs
@onready var hit_area : Panel = get_node("Hit")
@onready var crit_area : Panel = get_node("Crit")
@onready var super_area : Panel = get_node("Super")

# EXPORTs
@export var rangepoint_data : Resource = null

# DATA


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func adapt_rangepoint() -> void:
	
	var a_hit = rangepoint_data.get_hit_area()
	var a_crit = rangepoint_data.get_crit_area()
	var a_super = rangepoint_data.get_super_area()
	
	hit_area.size.x = a_hit
	hit_area.position.x = 0 - a_hit
	
	crit_area.size.x = a_crit
	crit_area.position.x = 0 - a_crit
	
	super_area.size.x = a_super
	super_area.position.x = 0 - a_super
	
	pass


func check_rangepoint(check_point:Vector2) -> String:
	var result = "Miss"
	
	if check_if_in(check_point, get_hitarea()):
		result = "Hit"
	
	if check_if_in(check_point, get_critarea()):
		result = "Crit"
	
	if check_if_in(check_point, get_superarea()):
		result = "Super"
	
	
	return result


func get_hitarea() -> Vector2:
	var result = Vector2(0, 0)
	
	result.x = hit_area.global_position.x
	result.y = hit_area.global_position.x + hit_area.size.x
	
	return result


func get_critarea() -> Vector2:
	var result = Vector2(0, 0)
	
	result.x = crit_area.global_position.x
	result.y = crit_area.global_position.x + crit_area.size.x
	
	return result


func get_superarea() -> Vector2:
	var result = Vector2(0, 0)
	
	result.x = super_area.global_position.x
	result.y = super_area.global_position.x + super_area.size.x
	
	return result


func check_if_in(pos:Vector2, area:Vector2) -> bool:
	if pos.x > area.x and pos.x <=area.y:
		return true
	else:
		return false
	




