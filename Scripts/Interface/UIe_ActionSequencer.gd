extends Control


# SIGNAL


# REFERENCEs
@onready var drum : TextureRect = get_node("Drum")
@onready var drum_ring : TextureRect = get_node("Drum/Ring")

# EXPORTs
@export_group("DRUM & SPIN")
@export var spin : bool = true
@export var drumspin_speed : float = 0.1
@export var spintime_scale : float = 1.0
@export var altdrumspin : Curve = null

# DATA
var current_spin : Curve = null
var spin_duration : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	spin_drum(_delta)
	pass


func spin_drum(_delta) -> void:
	
	if spin:
		var spin_var : float = 1.0 
		if current_spin != null:
			if spin_duration >= 1:
				spin_duration = 0
				current_spin = null
			else:
				spin_var = current_spin.sample(spin_duration)
				spin_duration += (1.0*_delta)*spintime_scale
				spin_duration = min(1.0, spin_duration)
			
		
		var drum_rot = drumspin_speed*spin_var
		drum.rotation += drum_rot
		drum_ring.rotation += (drum_rot*2.0)*-1.0
		
	
	pass


func add_spin(spin:Curve = altdrumspin) -> void:
	current_spin = spin
	spin_duration = 0


func _input(event):
	if event.is_action_released("ui_accept"):
		add_spin()
	pass


