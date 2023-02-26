extends Resource
class_name CharacterEquipment


# EQUIPS
@export var equipment_slots       : Dictionary = {
	"Main Hand"   : [],
	"Off Hand"    : [],
	"Outfit"      : [],
	"Accessories" : []
}


# REFERENCES 
var character_inventory : Resource = null
var temporary_stash : Array = []


# EQUIPMENT FUNCTIONS

func add_slot(slot_name:String, slot_number:int) -> void:
	if equipment_slots.has(slot_name):
		
		if slot_number != 0:
			var count = abs(slot_number)
			var equip_list : Array = equipment_slots[slot_name]
			for c in count:
				if slot_number >= 0:
					equip_list.append(EquipmentSlot.new())
				else:
					var siz = equip_list.size()
					if siz > 0:
						var back = equip_list.back()
						temporary_stash.append(back)
						equip_list.remove_at(siz-1)
						
					else:
						break
					
				
			
		
		
	else:
		if slot_number > 0:
			equipment_slots[slot_name] = []
			var count = abs(slot_number)
			var equip_list : Array = equipment_slots[slot_name]
			for c in count:
				equip_list.append(EquipmentSlot.new())
		pass
	pass


func equip(equipment:Resource, slot_index:int) -> Resource:
	var unequiped : Resource = null
	
	
	
	return unequiped



