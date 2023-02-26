extends BaseBMNode



# SIGNAL


# REFERENCE
@onready var folder_list : BoxContainer = get_node("Filter/Rows")
@onready var folder_filter : Control = get_node("Filter")
@onready var scroll : VScrollBar = get_node("Scroll")


# EXPORT
@export var folder_obj : PackedScene = preload("res://Scenes/Interface/Elements/SkillRelated/UIelement_SkillFolder.tscn")


# DATA
var character_saveddata : Dictionary = {}
var active_skillfolders : Array = []

var base_instance : Object = null


# Called when the node enters the scene tree for the first time.
func _ready():
	clean_skill_folders()
	update_scroll()
	folder_list.connect("resized", update_scroll)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func expand_or_hide_all(expand:bool = true) -> void:
	
	if expand:
		for ef in folder_list.get_childred():
			ef.expand_folder()
		
	else:
		for ef in folder_list.get_childred():
			ef.hide_folder()
		
	
	pass


func setup_character(actor:ActorProfile, save:bool = true) -> void:
	super.setup_character(actor)
	
	if character_focus != actor:
		if character_focus != null:
			var clean = false
			if !character_saveddata[character_focus.profile_name].is_empty():
				clean = true
			save_skill_folders(character_focus, clean)
		
		character_focus = actor
		
		if !character_saveddata.has(actor.profile_name):
			character_saveddata[actor.profile_name] = []
			place_skill_folders(actor)
			
		else:
			reuse_skill_folders(actor)
		
	
	pass


func clean_skill_folders() -> void:
	var f_list = folder_list.get_children()
	
	for sf in f_list:
		sf.queue_free()
	
	pass


func place_skill_folders(actor:ActorProfile) -> void:
	
	if base_instance == null:
		var folder_inst : Control = folder_obj.instantiate()
		folder_inst.origin = owner
		folder_inst.menu_node = self
		base_instance = folder_inst
	var skill_profile : CharacterSkills = actor.character_core.characterSkills
	var segment_list : Array = skill_profile.get_groups()
	
	for asl in segment_list:
		var folder_dupli = base_instance.duplicate()
		folder_list.add_child(folder_dupli)
		folder_dupli.setup_skillfolder(actor, asl)
		active_skillfolders.append(folder_dupli)
	
	pass


func save_skill_folders(actor:ActorProfile, preclean:bool = false) -> void:
	
	var pn = actor.profile_name
	if character_saveddata.has(pn):
		
		if preclean:
			character_saveddata[pn] = []
		
		for sf in folder_list.get_children():
			character_saveddata[pn].append(sf)
			folder_list.remove_child(sf)
			active_skillfolders.erase(sf)
		
	
	pass


func reuse_skill_folders(actor:ActorProfile) -> void:
	
	var pn = actor.profile_name
	if character_saveddata.has(pn):
		if !character_saveddata[pn].is_empty():
			var flist : Array = character_saveddata[pn]
			for ru in flist:
				folder_list.add_child(ru)
				active_skillfolders.append(ru)
		
	
	pass


# SCROLL FUNCTIONS

func update_scroll() -> void:
	var filter_s = folder_filter.size.y
	var row_s = folder_list.size.y
	
	var page_s = (row_s/filter_s)
	
	if page_s > 1.0:
		scroll.page = 100/page_s
	else:
		scroll.page = 100
	
	pass 


func scroll_menu() -> void:
	var filter_s = folder_filter.size.y
	var row_s = folder_list.size.y 
	
	if filter_s < row_s:
		var sd = row_s - filter_s
		var pos = scroll.value
		var tv = scroll.max_value - scroll.page
		var relative_pos = pos / tv
		var new_pos = sd*relative_pos
		folder_list.position.y = new_pos
		
	
	pass


func _on_scroll_scrolling():
	scroll_menu()
	pass # Replace with function body.
