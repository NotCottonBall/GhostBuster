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
	push_error("OnAction Was Not Implemented In One Of Item's Children")

func OnInbuiltAction() -> void:
	push_error("OnInbuiltAction Was Not Implemented In One Of Item's Children")