extends Control



# SIGNAL


# REFERENCEs
@onready var menu_nodes : Control = get_node("MenuNodes")
@onready var menu_tween : Tween = get_tree().create_tween()

# EXPORTs
@export var menunodes_anchor : Vector2 = Vector2(0.0, 0.0)
@export var menunodes_origin : Vector2 = Vector2(0.0, 0.0)
@export var use_origintween  : bool = false

# DATA
var menu_step : int = 0
var node_list : Array = []
var steps : Dictionary = {0 : null, 1 : null}
var current_menu : Object = null

var character_in_focus : ActorProfile = null

var scroller_tween : Tween = null
var current_scroll : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	menu_tween.bind_node(self)
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
	
	slot_menu_by_name("Base")
	pass


func reset_menu() -> void:
	menu_step = 0
	steps = {0 : null, 1 : null}
	current_menu = null
	menu_nodes.position = menunodes_anchor
	
	pass


func initiate_accountinfo() -> void:
	pass


func get_menu_by_name(menu_name:String) -> BaseBMNode:
	var result = null
	
	for gn in node_list:
		if gn.name == menu_name:
			result = gn
			break
		
	
	return result


func get_all_menus() -> Array:
	var result : Array = []
	var menus : Array = get_node("MenuNodes").get_children()
	for gc in menus:
		result.append(gc)
		pass
	
	return result


func slot_menu_by_name(menu_name:String) -> void:
	var menu = get_menu_by_name(menu_name)
	var old_menu = current_menu
	current_menu = menu
	if menu_step >= 1:
		scroll_menu_basis(old_menu)
	
	menu_step += 1
	steps[menu_step] = current_menu
	
	# ANIMS
	if old_menu != null:
		old_menu.open(false)
		
		menu.move_to_menu_link(old_menu, use_origintween)
	else:
		menu.move_to_menu_origin(use_origintween)
	
	menu.open()
	menu.setup_character(character_in_focus)
	move_to_node(menu)
	
	pass


func scroll_menu_basis(next_menu:BaseBMNode, forward:bool = true, time:float = 0.2) -> void:
	var link_pos = next_menu.get_link_pos()
	var new_pos = Vector2(0, 0)
	if forward:
		current_scroll -= link_pos.x
		new_pos = Vector2(current_scroll, 0.0)
	else:
		current_scroll += link_pos.x
		new_pos = Vector2(current_scroll, 0.0)
	
	if scroller_tween == null:
		scroller_tween = create_tween()
	scroller_tween.tween_property(menu_nodes, "position", new_pos, time)
	
	pass


func move_to_node(menunode:BaseBMNode, time:float = 0.3) -> void:
	
	var pos = menunode.position
	var new_pos = Vector2(pos.x*-1, 0.0)
	
	menu_tween.tween_property(menu_nodes, "position", new_pos, time)
	
	pass



