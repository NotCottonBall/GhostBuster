extends Item
class_name Flashlight

@export var m_Light: Light3D

func _init() -> void:
  ItemID = HoldableItems.Flashlight

func _ready() -> void:
  m_Light = $SpotLight3D
  m_Light.visible = false

func OnAction() -> void:
  IsOn = !IsOn
  m_Light.visible = !m_Light.visible


func OnInbuiltAction() -> void:
  m_Light.visible = !m_Light.visible