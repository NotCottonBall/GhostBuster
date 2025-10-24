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
	item.rotation_degrees = item.HoldingRotation
	item.freeze = true

func DropItem(index: int, newSpawnLocation: Transform3D, parent: Node) -> void:
	if index >= MaxHoldableItems or not is_instance_valid(PlayerInventory[index]):
		return

	var item: Item = PlayerInventory[index]
	PlayerInventory[index] = null
	remove_child(item)

	parent.add_child(item)
	item.transform = newSpawnLocation
	item.freeze = false
	item.ToggleSignal.emit(false)

func SwitchHoldingItem(oldIndex: int, newIndex: int) -> void:
	if is_instance_valid(PlayerInventory[oldIndex]):
		var item: Item = PlayerInventory[oldIndex]
		item.ToggleSignal.emit(false)
		item.ItemMesh.visible = false
	
	if is_instance_valid(PlayerInventory[newIndex]):
		var item: Item = PlayerInventory[newIndex]
		item.ItemMesh.visible = true
		CurrentHoldingItem = item
