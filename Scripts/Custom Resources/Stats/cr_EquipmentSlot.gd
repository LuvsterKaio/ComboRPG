extends Resource
class_name EquipmentSlot


signal item_slotted(item:Resource)
signal item_removed(item:Resource)

# INFO
@export var slotName : String = "Weapon"
@export var slotTags : Array[String] = []

@export var itemSlotted : Resource = null
var slotFilled : bool = false



func get_item() -> Resource:
	var result = null
	if itemSlotted != null:
		result = itemSlotted
	
	return result

func is_filled() -> bool:
	return slotFilled


func remove_item() -> Resource:
	var result = null
	if itemSlotted != null:
		result = itemSlotted
		itemSlotted = null
		slotFilled = false
		emit_signal("item_removed", result)
		emit_changed()
	
	return result


func slot_item(item:Resource, can_swap:bool = false) -> Resource:
	var result = null
	var can_slot = true
	if is_filled():
		if can_swap:
			result = remove_item()
		else:
			can_slot = false
		
	if can_slot:
		itemSlotted = item
		slotFilled = true
		emit_signal("item_slotted", item)
		emit_changed()
	
	return result



