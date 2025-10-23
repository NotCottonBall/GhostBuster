extends RigidBody3D
class_name Item

enum HoldableItems
{
	None = 0,
	Flashlight,
	EMFSDetector,
	MotionSensor,
	SoundSensor,
	Thermometer
}

@export var ItemID: HoldableItems
@export var ItemMesh: Node3D

func OnAction() -> void:
	pass

func OnInbuiltAction() -> void:
	pass

func _process(delta: float) -> void:
	pass