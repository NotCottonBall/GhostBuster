extends Node3D
class_name ItemHolder

var CurrentHoldingItem: Item
var PlayerInventory: Array[Item] = []
@export var MaxHoldableItems: int = 3

func _ready() -> void:
	CurrentHoldingItem = null
	PlayerInventory.resize(MaxHoldableItems)
	PlayerInventory.fill(null)


func _process(delta: float) -> void:
	pass


func HoldItem(index: int, item: Item) -> void:
	if index >= MaxHoldableItems or is_instance_valid(PlayerInventory[index]):
		return
	
	item.get_parent().remove_child(item)
	PlayerInventory[index] = item
	add_child(item)
	item.transform = Transform3D.IDENTITY


func DropItem(index: int) -> void:
	if index >= MaxHoldableItems or not is_instance_valid(PlayerInventory[index]):
		return
	
	PlayerInventory[index] = null
	remove_child(PlayerInventory[index])


func SwitchHoldingItem(index: int) -> void:
	pass