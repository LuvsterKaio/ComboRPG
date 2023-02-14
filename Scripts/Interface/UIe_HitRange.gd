extends Control



# SIGNAs


# REFERENCEs
@onready var skills_used_e : HBoxContainer = get_node("SkillUsed")
@onready var skill_name : Label = get_node("SkillName")
@onready var _range : Control = get_node("Filter/Range")
@onready var animator : AnimationPlayer = get_node("Animator")
@onready var rangepoint_object : Object = preload("res://Scenes/ResourceScenes/CombatSceneResources/csr_RangePoint.tscn")

# EXPORTs
@export var speed_mod : float = 1.0
@export var speed_curve : Curve = null

# DATA
var open : bool = false
var active : bool = false
var range_data : Resource = null
var current_lenght : float = 500.0

var points : Array = []



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_hitrange(_range_data:Resource, new_speed:float = 1.0) -> void:
	
	# START
	if !active:
		active = true
		if range_data != _range_data:
			
			if open:
				animator.play("Restart")
			
			else:
				animator.play("Open")
				open = true
			
			setup_range(_range_data)
		
		await animator
		
	
	
	pass


func setup_range(rd:RangeData) -> void:
	
	delete_points()
	
	var count = 0
	range_data = rd
	
	for l in range_data.points:
		
		var p = range_data.get_point_and_position(count)
		set_range_point(p[0], p[1])
		
		count += 1
	
	pass


func set_range_point(point_data:RangePointData, pos_x:float) -> void:
	
	var point = rangepoint_object.instantiate()
	point.rangepoint_data = point_data
	point.adapt_rangepoint()
	
	_range.add_child(point)
	
	pass


func delete_points() -> void:
	
	for r in _range.get_children():
		r.queue_free()
		pass
	
	pass





