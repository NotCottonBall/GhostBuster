extends CharacterBody3D

@export_group("Movement Settings")
var m_CurrentPlayerSpeed: float = 0.0
var m_CurrentPlayerStamina: float = 0.0
var m_Collider: CapsuleShape3D
@export var PlayerRunSpeed: float = 8.0
@export var PlayerWalkSpeed: float = 5.0
@export var PlayerMaxStamina: float = 100.0
@export var StaminaReductionRate: float = 30.0
@export var StaminaGainRate: float = 10.0
@export var CrouchHeight: float = 0.8
@export var StandHeight: float = 2.0

# Todo: Remove this before exporting
var m_MouseCaptured: bool = true

@export_group("Camera Settings")
var m_Camera: Camera3D
var m_Yaw: float = 0.0
var m_Pitch: float = 0.0
@export var MouseSensiticity: float = 0.2

@export_group("Item Holder")
var m_ItemHolder: ItemHolder
var m_CurrentHoldingIndex: int = 0
@export var m_InteractionRayLength: float = 2.5

func _ready() -> void:
	m_CurrentPlayerSpeed = PlayerWalkSpeed
	m_CurrentPlayerStamina = PlayerMaxStamina
	m_Camera = $Head/Camera3D
	m_ItemHolder = $Head/ItemHolder
	m_Collider = $CollisionShape3D.shape
	
	if m_MouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	m_Pitch = 0.0

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("Sprint") and m_CurrentPlayerStamina > 0.0:
		EnableSprint(delta)
	else:
		DisableSprint(delta)
	
	if Input.is_action_pressed("Crouch"):
		m_Collider.height = CrouchHeight
	else:
		m_Collider.height = StandHeight

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
		m_Yaw -= event.relative.x * MouseSensiticity
		m_Pitch -= event.relative.y * MouseSensiticity
		m_Pitch = clamp(m_Pitch, -89.0, 89.0)

		rotation_degrees.y = m_Yaw
		$Head.rotation_degrees.x = m_Pitch

	if event.is_action_pressed("SecondaryAction"):
		var item: Item = m_ItemHolder.PlayerInventory[m_CurrentHoldingIndex]
		if item:
			item.OnAction()

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
	var ray: Dictionary = Raycast()
	if ray.is_empty():
		return

	if ray.collider is Item:
		var item: Item = ray.collider
		m_ItemHolder.HoldItem(m_CurrentHoldingIndex, item)
	
	if ray.collider is Door:
		print(ray.collider.name)
		ray.collider.ToggleDoor()


func Raycast() -> Dictionary:
	var viewportSize: Vector2 = get_viewport().get_visible_rect().size
	var viewportCenter: Vector2 = viewportSize / 2
	
	var rayOrigin: Vector3 = m_Camera.project_ray_origin(viewportCenter)
	var rayDirection: Vector3 = m_Camera.project_ray_normal(viewportCenter)
	var rayEnd: Vector3 = rayOrigin + rayDirection * m_InteractionRayLength

	var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	ray.collide_with_areas = true
	ray.collide_with_bodies = true

	var spaceState: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	return spaceState.intersect_ray(ray)


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
