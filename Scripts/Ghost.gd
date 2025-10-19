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
@export var InteractionRadius: float = 4.5
@export var HintRadius: float = 6.0
@export var PlayerDetectionRadius: float = 4.0
@export var ThrowChance: float = 0.1
@export var ThrowForce: float = 5.0

@export_group("Ghost Hunt Specifications")
var m_IsHunting: bool = false
var m_PlayerFound: bool = false
@export var HuntChance: float = 0.05

@export_group("Movement Settings")
@export var MovementSpeed: float = 400.0

var m_NavCooldownTimer: Timer
var m_NavTimeout: Timer
var m_HuntCooldown: Timer
var m_PlayerDetectionCooldown: Timer


func _ready() -> void:
	if m_SpawnPoints.is_empty():
		push_error("Ghost Spawnpoints Can't Be Empty")
	
	$InteractionArea/CollisionShape3D.shape.radius = InteractionRadius
	m_NavAgent = $NavigationAgent3D
	m_NavCooldownTimer = $NavCooldownTimer
	m_NavTimeout = $NavTimeoutTimer
	m_HuntCooldown = $HuntCooldown
	m_PlayerDetectionCooldown = $PlayerDetectionCooldown

	SelectSpawn()


func _process(delta: float) -> void:
	if randf() < ThrowChance * delta:
		TryThrowSomething()

	if randf() < HuntChance * delta:
		m_IsHunting = true

	TryLookForPlayer()
	if m_PlayerFound == false:
		GoToNextNavPos(delta, m_NavCooldownTimer)
	
	GoToNextNavPos(delta, m_PlayerDetectionCooldown)

	# print(m_PlayerFound)


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


func TryLookForPlayer() -> void:
	var area: Area3D = $PlayerDetectionArea
	var overlappingObjs: Array[Node3D] = area.get_overlapping_bodies()
	var player: Player = null
	
	for i in overlappingObjs:
		if i is Player:
			player = i
			break

	if player == null:
		m_PlayerDetectionCooldown.start()
		return
	
	var visionRaycast: RayCast3D = $VisionRaycast
	visionRaycast.target_position = visionRaycast.to_local(player.global_position)
	visionRaycast.force_raycast_update()
	
	if not visionRaycast.is_colliding():
		return


	var collider: Object = visionRaycast.get_collider()
	print(collider.name)
	if collider == player:
		m_PlayerFound = true
		m_NavAgent.target_position = player.global_position


func GoToNextNavPos(delta: float, timeout: Timer) -> void:
	if m_NavAgent.is_navigation_finished():
		if timeout.is_stopped():
			timeout.start()
		velocity = Vector3.ZERO
		return

	if m_NavAgent.is_target_reached() == false:
		var newPos: Vector3 = m_NavAgent.get_next_path_position()
		var dir: Vector3 = newPos - global_position
		velocity = dir * MovementSpeed * delta
		dir.y = 0
		look_at(global_position + -dir.normalized())


func _on_nav_cooldown_timer_timeout() -> void:
	PickRandomNavLocation()

func _on_nav_timeout_timer_timeout() -> void:
	PickRandomNavLocation()


func _on_player_detection_cooldown_timeout() -> void:
	m_PlayerFound = false
