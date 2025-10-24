extends Item
class_name EMFDetector

@export var EMFLevelTextures: Array[Texture2D] = []
@export var EMFMaterial: StandardMaterial3D = null

func _init() -> void:
  ItemID = HoldableItems.EMFDetector

func OnAction() -> void:
  IsOn = !IsOn
  if IsOn:
    EMFMaterial.emission_texture = EMFLevelTextures[0]
  else:
    EMFMaterial.emission_texture = null

func OnHintGiven(hintItem: Item.HoldableItems) -> void:
  if IsOn:
    EMFMaterial.emission_texture = EMFLevelTextures[4]
    await get_tree().create_timer(3.0).timeout
    if IsOn:
      EMFMaterial.emission_texture = EMFLevelTextures[0]
    else:
      EMFMaterial.emission_texture = null
