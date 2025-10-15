extends RigidBody3D
class_name Item

enum HoldableItems
{
	None = 0,
	Flashlight,
	EMFSDetector,
	MotionSensor,
	Thermometer
}

# EMF Thermo = Sprit
# EMF Motion = Demon
# Motion Thermo = Oni

@export var ItemID: HoldableItems

func OnAction() -> void:
	pass

func OnInbuiltAction() -> void:
	pass

func _process(delta: float) -> void:
	pass