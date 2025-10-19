extends StaticBody3D
class_name Door

@export var m_CloseRotation: float = 0.0
@export var m_OpenRotation: float = 0.0

@export var m_IsDoorOpen: bool = false

func OpenDoor() -> void:
  rotation_degrees.y = m_OpenRotation
  m_IsDoorOpen = true
func CloseDoor() -> void:
  rotation_degrees.y = m_CloseRotation
  m_IsDoorOpen = false

func ToggleDoor() -> void:
  m_IsDoorOpen = !m_IsDoorOpen
  if m_IsDoorOpen:
    OpenDoor()
  else:
    CloseDoor()