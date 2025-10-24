extends Item
class_name SpiritBox

@export var SBMaterial: StandardMaterial3D = null

func _init() -> void:
	ItemID = HoldableItems.SpiritBox


func OnAction() -> void:
	IsOn = !IsOn
	if IsOn:
		SBMaterial.emission_enabled = true
	else:
		SBMaterial.emission_enabled = false

func HintCallback() -> void:
	if IsOn:
		print("<Random Spirit Box Voice>")

func ToggleCallback(toggle: bool) -> void:
	IsOn = toggle
	if IsOn:
		SBMaterial.emission_enabled = true
	else:
		SBMaterial.emission_enabled = false
