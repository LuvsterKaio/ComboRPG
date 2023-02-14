extends Control



# SIGNAL


# REFERENCEs
@onready var menu_nodes : Control = get_node("MenuNodes")
@onready var menu_tween : Tween = get_tree().create_tween()

# EXPORTs
@export var menunodes_anchor : Vector2 = Vector2(0.0, 0.0)
@export var menunodes_origin : Vector2 = Vector2(0.0, 0.0)

# DATA
var menu_step : int = 0
var node_list : Array = []
var steps : Dictionary = {0 : null, 1 : null}
var current_menu : Object = null

var character_in_focus : ActorProfile = null


# Called when the node enters the scene tree for the first time.
func _ready():
	preparation()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func preparation() -> void:
	
	# GET AND HIDE OTHER MENU NODES
	node_list = get_all_menus()
	for im in node_list:
		im.visible = false
		im.controller = self
	
	
	pass


func initiate_menu_on_character(actor:ActorProfile) -> void:
	character_in_focus = actor
	
	for sc in node_list:
		sc.setup_character(character_in_focus)
	
	get_menu_by_name("Base")
	


func reset_menu() -> void:
	menu_step = 0
	steps = {0 : null, 1 : null}
	current_menu = null
	menu_nodes.position = menunodes_anchor
	
	pass


func focus_on_character(actor:ActorProfile) -> void:
	var menunodes = node_list
	
	pass


func initiate_accountinfo() -> void:
	pass


func get_menu_by_name(menu_name:String) -> BaseBMNode:
	var result = null
	
	result = menu_nodes.get_node_or_null(menu_name)
	
	return result


func get_all_menus() -> Array:
	var result = menu_nodes.get_children()
	
	return result


func slot_menu_by_name(menu_name:String) -> void:
	var menu = get_menu_by_name(menu_name)
	var old_menu = current_menu
	current_menu = menu
	menu_step += 1
	steps[menu_step] = current_menu
	
	# ANIMS
	if old_menu != null:
		old_menu.open(false)
		menu.move_to_menu_link(old_menu)
	else:
		menu.move_to_menu_origin()
	
	menu.open()
	menu.setup_character(character_in_focus)
	move_to_node(menu)
	
	pass


func move_to_node(menunode:BaseBMNode, time:float = 0.3) -> void:
	
	var pos = menunode.position
	var new_pos = Vector2(pos.x*-1, 0.0)
	
	menu_tween.tween_property(menu_nodes, "position", new_pos, time)
	
	pass



