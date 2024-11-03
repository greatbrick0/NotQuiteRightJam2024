extends Resource
class_name WaveData

@export var hasEnemies: bool = true
@export var enemies: Array[EnemySpawnData]
@export var waveNode: NodePath
@export var loopWave: bool = false
@export var cameraBehaviour: String = "lock"
@export var cameraOffset: float = 0
@export var cameraBounds: Vector2 = Vector2(0, 100000)
@export var backgroundMusic: int = 0
