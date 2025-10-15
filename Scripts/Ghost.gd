extends CharacterBody3D
class_name Ghost

var m_NavAgent: NavigationAgent3D

enum GhostTypes {
	None,
	Sprit,
	Demon,
	Oni,
}

@export_group("Ghost Specifications")
@export var m_SpawnPoints: Array[Node3D]
@export var Type: GhostTypes = GhostTypes.None
@export var InteractionRadius: float = 5.0
@export var HintRadius: float = 8.0
@export var ThrowChance: float = 0.1
@export var ThrowForce: float = 5.0

@export_group("Movement Settings")
@export var MovementSpeed: float = 400.0
@export var TurnSpeed: float = 50.0

var m_NavCooldownTimer: Timer
var m_NavTimeout: Timer


func _ready() -> void:
	if m_SpawnPoints.is_empty():
		push_error("Ghost Spawnpoints Can't Be Empty")
	
	$InteractionArea/CollisionShape3D.shape.radius = InteractionRadius
	m_NavAgent = $NavigationAgent3D
	m_NavCooldownTimer = $NavCooldownTimer
	m_NavTimeout = $NavTimeoutTimer

	SelectSpawn()


func _process(delta: float) -> void:
	if randf() < ThrowChance * delta:
		TryThrowSomething()
	MoveToRandomPoint(delta)

func MoveToRandomPoint(delta: float) -> void:
	if m_NavAgent.is_navigation_finished():
		if m_NavCooldownTimer.is_stopped():
			m_NavCooldownTimer.start()
		velocity = Vector3.ZERO
		return

	if m_NavAgent.is_target_reached() == false:
		var newPos: Vector3 = m_NavAgent.get_next_path_position()
		var dir: Vector3 = (newPos - global_position).normalized()
		velocity = dir * MovementSpeed * delta
	
func PickRandomNavLocation() -> void:
	var navMapRID: RID = m_NavAgent.get_navigation_map()

	var randomPoint: Vector3 = NavigationServer3D.map_get_random_point(navMapRID, m_NavAgent.navigation_layers, false)
	var randomPos: Vector3 = NavigationServer3D.map_get_closest_point(navMapRID, randomPoint)
	m_NavAgent.target_position = randomPos
	m_NavTimeout.start()


func _physics_process(delta: float) -> void:
	if is_on_floor() == false:
		velocity += get_gravity() * delta

	move_and_slide()

func SelectSpawn() -> void:
	var rand: Node3D = m_SpawnPoints.pick_random()
	position.x = rand.position.x
	position.z = rand.position.z

func TryThrowSomething() -> void:
	var overlappingObjs: Array[Node3D] = $InteractionArea.get_overlapping_bodies()
	var throwableObjs: Array[Throwable] = []

	for obj in overlappingObjs:
		if obj is Throwable:
			throwableObjs.append(obj)

	if throwableObjs.size() > 0:
		var target: Throwable = throwableObjs.pick_random()

		var randomDir: Vector3 = Vector3(randf_range(-1, 1), randf_range(1.0, 2.0), randf_range(-1, 1)).normalized()
		var force: Vector3 = randomDir * ThrowForce

		target.apply_impulse(force)
		print(target.name)


func _on_nav_cooldown_timer_timeout() -> void:
	PickRandomNavLocation()


func _on_nav_timeout_timer_timeout() -> void:
	PickRandomNavLocation()
