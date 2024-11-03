extends Node2D

@export var enemyRefs: Array[PackedScene]
@export var currentWave: int = 0
@export var waves: Array[WaveData]

var instanceRef: Node
var spawningEnemies: bool = false
var nextEnemyTime: float
var enemySpawnCounter: int = 0

func _ready():
	QueueEnemies()

func QueueEnemies() -> void:
	spawningEnemies = true
	enemySpawnCounter = 0
	nextEnemyTime = waves[currentWave].enemies[0].enemySpawnTime

func _process(delta):
	nextEnemyTime -= 1.0 * delta
	if(nextEnemyTime <= 0 and spawningEnemies):
		instanceRef = enemyRefs[waves[currentWave].enemies[enemySpawnCounter].enemyTypeIndex].instantiate()
		instanceRef.playerRef = %Player
		instanceRef.global_position = get_node(waves[currentWave].waveNode).get_child(
			waves[currentWave].enemies[enemySpawnCounter].enemySpotIndex).global_position
		add_child(instanceRef)
		enemySpawnCounter += 1
		if(enemySpawnCounter >= len(waves[currentWave].enemies)):
			if(waves[currentWave].loopWave):
				QueueEnemies()
			else:
				spawningEnemies = false
		else:
			nextEnemyTime = waves[currentWave].enemies[enemySpawnCounter].enemySpawnTime
