extends CharacterBody3D
class_name Ghost

@export_group("Ghost Specifications")
@export var m_SpawnPoints: Array[Node3D]
@export var InteractionRadius: float = 5.0
@export var ThrowChance: float = 0.1
@export var ThrowForce: float = 5.0

@export_group("Movement Settings")
@export var MovementSpeed: float = 10.0
@export var TurnSpeed: float = 5.0


func _ready() -> void:
  if m_SpawnPoints.is_empty():
    push_error("Ghost Spawnpoints Can't Be Empty")
  $InteractionArea/CollisionShape3D.shape.radius = InteractionRadius

  SelectSpawn()


func _process(delta: float) -> void:
  if randf() < ThrowChance * delta:
    TryThrowSomething()

func _physics_process(delta: float) -> void:
  pass


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
    print(force)
    print(randomDir)