extends RigidBody3D
class_name Item

enum HoldableItems
{
	None = 0,
	Flashlight,
	EMFDetector,
	MotionSensor,
	SoundSensor,
	Thermometer
}

@export var ItemID: HoldableItems
@export var ItemMesh: Node3D
var IsOn: bool = false

func OnAction() -> void:
	pass

func OnInbuiltAction() -> void:
	pass

func HintCallback() -> void:
	pass

func OnHintGiven(hintItem: Item.HoldableItems) -> void:
	if hintItem == ItemID:
		HintCallback()


func _ready() -> void:
	GlobalSignals.GhostProduceHintSignal.connect(Callable(self, "OnHintGiven"))

func _process(delta: float) -> void:
	pass