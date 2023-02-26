extends Resource
class_name SequenceData


# SIGNAL
signal command_added(command:BattleCommand)
signal command_removed(command:BattleCommand)


# REFERENCEs
var character_owner : ActorProfile = null

# EXPORTs


# DATA
	# Commands
var command_list : Array[BattleCommand] = []
	# Costs
var ap_used       : int = 0
var ep_used       : int = 0
var hp_used       : int = 0
var od_used       : int = 0
var stress_gained : int = 0
	# Sequence Effects
var sequence_effects : Array = []


# FUNCTIONs

func add_command(command:BattleCommand) -> void:
	command_list.append(command)
	var ss = command.stats_spent
	ap_used += ss["AP"]
	hp_used += ss["HP"]
	ep_used += ss["EP"]
	od_used += ss["OD"]
	stress_gained += ss["Stress"]
	emit_signal("command_added", command)
	emit_changed()
	pass


func remove_command(command:BattleCommand) -> void:
	
	if command_list.has(command):
		var ss = command.stats_spent
		command_list.erase(command)
		ap_used -= ss["AP"]
		hp_used -= ss["HP"]
		ep_used -= ss["EP"]
		od_used -= ss["OD"]
		stress_gained -= ss["Stress"]
		emit_signal("command_removed", command)
		emit_changed()
	
	pass

