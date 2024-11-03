extends Resource
class_name WaveData

@export var hasEnemies: bool = true
@export var enemies: Array[EnemySpawnData]
@export var waveNode: NodePath
@export var loopWave: bool = false
@export var cameraBehaviour: String = "lock"
@export var backgroundMusic: int = 0
