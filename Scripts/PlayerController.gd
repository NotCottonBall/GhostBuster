extends CharacterBody3D


var m_CurrentPlayerSpeed: float = 0.0
var m_CurrentPlayerStamina: float = 0.0
var m_Yaw: float = 0.0
var m_Pitch: float = 0.0

@export_group("Movement Settings")
@export var PlayerRunSpeed: float = 8.0
@export var PlayerWalkSpeed: float = 5.0
@export var PlayerMaxStamina: float = 100.0
@export var StaminaReductionRate: float = 30.0
@export var StaminaGainRate: float = 10.0

@export_group("Camera Settings")
@export var MouseSensiticity: float = 0.4

func _ready() -> void:
	m_CurrentPlayerSpeed = PlayerWalkSpeed
	m_CurrentPlayerStamina = PlayerMaxStamina
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	m_Pitch = 0.0

func _process(delta: float) -> void:
	print(m_CurrentPlayerStamina)

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
		m_Yaw -= event.relative.x * MouseSensiticity
		m_Pitch -= event.relative.y * MouseSensiticity
		m_Pitch = clamp(m_Pitch, -89.0, 89.0)

		rotation_degrees.y = m_Yaw
		$Head.rotation_degrees.x = m_Pitch

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
