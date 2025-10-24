extends RigidBody3D
class_name Item

enum HoldableItems
{
	None = 0,
	Flashlight,
	EMFDetector,
	MotionSensor,
	SpiritBox,
	Thermometer
}

signal ToggleSignal(toggle: bool)

var IsOn: bool = false
@export var ItemID: HoldableItems
@export var ItemMesh: Node3D
@export var HoldingRotation: Vector3

func OnAction() -> void:
	pass

func OnInbuiltAction() -> void:
	pass

func HintCallback() -> void:
	pass

func OnHintGiven(hintItem: Item.HoldableItems) -> void:
	if hintItem == ItemID:
		HintCallback()

func ToggleCallback(toggle: bool) -> void:
	pass


func _ready() -> void:
	GlobalSignals.GhostProduceHintSignal.connect(Callable(self, "OnHintGiven"))
	ToggleSignal.connect(Callable(self, "ToggleCallback"))

func _process(delta: float) -> void:
	pass