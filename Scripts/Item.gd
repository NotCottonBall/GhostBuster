extends StaticBody3D
class_name Item

enum HoldableItems
{
	None = 0,
	Flashlight,
	EMFSDetector,
	MotionSensor,
	Thermometer
}

@export var ItemID: HoldableItems

func OnAction() -> void:
	pass

func OnInbuiltAction() -> void:
	pass