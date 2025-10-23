extends CharacterBody3D
class_name Player

@export_group("Movement Settings")
var m_CurrentPlayerSpeed: float = 0.0
var m_CurrentPlayerStamina: float = 0.0
var m_Collider: CapsuleShape3D
@export var PlayerRunSpeed: float = 6.0
@export var PlayerWalkSpeed: float = 2.5
@export var PlayerMaxStamina: float = 100.0
@export var StaminaReductionRate: float = 30.0
@export var StaminaGainRate: float = 10.0
@export var CrouchHeight: float = 0.8
@export var StandHeight: float = 2.0

# DEBUG_ONLY	
var m_MouseCaptured: bool = true
#

@export_group("Camera Settings")
var m_Camera: Camera3D
var m_Yaw: float = 0.0
var m_Pitch: float = 0.0
@export var MouseSensitivity: float = 0.2
@export var ControllerCamSensitivity: float = 0.8

@export_group("Item Holder")
var m_Raycast: RayCast3D
var m_ItemHolder: ItemHolder
var m_CurrentHoldingIndex: int = 0

func _ready() -> void:
	m_CurrentPlayerSpeed = PlayerWalkSpeed
	m_CurrentPlayerStamina = PlayerMaxStamina
	m_Camera = $Head/Camera3D
	m_Raycast = $Head/RayCast3D
	m_ItemHolder = $Head/ItemHolder
	m_Collider = $CollisionShape3D.shape
	
	if m_MouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	m_Pitch = 0.0

func _process(delta: float) -> void:
	var camMotionVectorX: float = Input.get_axis("LookLeft", "LookRight")
	var camMotionVectorY: float = Input.get_axis("LookDown", "LookUp")
	if camMotionVectorX != 0.0 or camMotionVectorY != 0.0:
		# DEBUG_ONLY
		if m_MouseCaptured:
		#
			m_Yaw -= camMotionVectorX * ControllerCamSensitivity
			m_Pitch += camMotionVectorY * ControllerCamSensitivity
			m_Pitch = clamp(m_Pitch, -89.0, 89.0)
			rotation_degrees.y = m_Yaw
			$Head.rotation_degrees.x = m_Pitch

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("Sprint") and m_CurrentPlayerStamina > 0.0:
		EnableSprint(delta)
	else:
		DisableSprint(delta)

	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * m_CurrentPlayerSpeed
		velocity.z = direction.z * m_CurrentPlayerSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, m_CurrentPlayerSpeed)
		velocity.z = move_toward(velocity.z, 0, m_CurrentPlayerSpeed)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# DEBUG_ONLY
		if m_MouseCaptured:
		#
			m_Yaw -= event.relative.x * MouseSensitivity
			m_Pitch -= event.relative.y * MouseSensitivity
			m_Pitch = clamp(m_Pitch, -89.0, 89.0)
			rotation_degrees.y = m_Yaw
			$Head.rotation_degrees.x = m_Pitch

	if Input.is_action_just_pressed("Crouch"):
		m_Collider.height = CrouchHeight
	if Input.is_action_just_released("Crouch"):
		position.y += CrouchHeight / 2
		m_Collider.height = StandHeight

	if event.is_action_pressed("SecondaryAction"):
		var item: Item = m_ItemHolder.PlayerInventory[m_CurrentHoldingIndex]
		if item:
			item.OnAction()
	if event.is_action_pressed("InbuiltAction"):
		for i: int in m_ItemHolder.PlayerInventory.size():
			var item: Item = m_ItemHolder.PlayerInventory[i]
			if item and item.ItemID == Item.HoldableItems.Flashlight:
				item.OnInbuiltAction()

	if event.is_action_pressed("Pause"):
		m_MouseCaptured = !m_MouseCaptured
		if m_MouseCaptured:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("Interact"):
		Interact()
	if event.is_action_pressed("Drop"):
		m_ItemHolder.DropItem(m_CurrentHoldingIndex, transform, get_parent())
	
	if event.is_action_pressed("FirstHolder"):
		m_ItemHolder.SwitchHoldingItem(m_CurrentHoldingIndex, 0)
		m_CurrentHoldingIndex = 0
	if event.is_action_pressed("SecondHolder"):
		m_ItemHolder.SwitchHoldingItem(m_CurrentHoldingIndex, 1)
		m_CurrentHoldingIndex = 1
	if event.is_action_pressed("ThirdHolder"):
		m_ItemHolder.SwitchHoldingItem(m_CurrentHoldingIndex, 2)
		m_CurrentHoldingIndex = 2
	if event.is_action_pressed("SwitchHolder"):
		m_ItemHolder.SwitchHoldingItem(m_CurrentHoldingIndex, (m_CurrentHoldingIndex + 1) % m_ItemHolder.MaxHoldableItems)
		m_CurrentHoldingIndex = (m_CurrentHoldingIndex + 1) % m_ItemHolder.MaxHoldableItems

func Interact() -> void:
	if not m_Raycast.is_colliding():
		return

	var collider: Object = m_Raycast.get_collider()
	if collider == null:
		return

	if collider is Item:
		var item: Item = collider
		m_ItemHolder.HoldItem(m_CurrentHoldingIndex, item)
	if collider is Door:
		collider.ToggleDoor()


func EnableSprint(delta: float) -> void:
	m_CurrentPlayerSpeed = PlayerRunSpeed
	if velocity.length() > 0.0:
		m_CurrentPlayerStamina -= StaminaReductionRate * delta
	m_CurrentPlayerSpeed = clamp(m_CurrentPlayerSpeed, 0.0, PlayerMaxStamina)

func DisableSprint(delta: float) -> void:
	m_CurrentPlayerSpeed = PlayerWalkSpeed
	if m_CurrentPlayerStamina < PlayerMaxStamina and not Input.is_action_pressed("Sprint"):
		m_CurrentPlayerStamina += StaminaGainRate * delta
	m_CurrentPlayerSpeed = clamp(m_CurrentPlayerSpeed, 0.0, PlayerMaxStamina)
