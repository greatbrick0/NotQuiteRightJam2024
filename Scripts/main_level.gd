extends Node2D

@export var enemyRefs: Array[PackedScene]
@export var currentWave: int = 0
@export var waves: Array[WaveData]

var instanceRef: Node
var spawningEnemies: bool = false
var nextEnemyTime: float
var enemySpawnCounter: int = 0

var enemyKillCount: int = 0

func _ready():
	currentWave = -1
	NewWave()

func QueueEnemies() -> void:
	spawningEnemies = true
	enemySpawnCounter = 0
	nextEnemyTime = waves[currentWave].enemies[0].enemySpawnTime

func NewWave() -> void:
	currentWave += 1
	if(waves[currentWave].hasEnemies):
		QueueEnemies()
	$ControlledCamera.ChangeBehaviour(
		waves[currentWave].cameraBehaviour, 
		get_node(waves[currentWave].waveNode),
		waves[currentWave].cameraOffset, 
		waves[currentWave].cameraBounds
	)
	MusicManager.ChangeTrack(waves[currentWave].backgroundMusic)

func _process(delta):
	nextEnemyTime -= 1.0 * delta
	if(nextEnemyTime <= 0 and spawningEnemies):
		WaveSpawn()
	
	if(currentWave == 0 and enemyKillCount == 4):
		NewWave()
		enemyKillCount = 0
	elif(currentWave == 2 and enemyKillCount == 2):
		NewWave()
		enemyKillCount = 0
	elif(currentWave == 5 and enemyKillCount == 6):
		NewWave()
		enemyKillCount = 0

func WaveSpawn() -> void:
	instanceRef = enemyRefs[waves[currentWave].enemies[enemySpawnCounter].enemyTypeIndex].instantiate()
	instanceRef.playerRef = %Player
	instanceRef.global_position = get_node(waves[currentWave].waveNode).get_child(
		waves[currentWave].enemies[enemySpawnCounter].enemySpotIndex).global_position
	add_child(instanceRef)
	enemySpawnCounter += 1
	if(enemySpawnCounter >= len(waves[currentWave].enemies)):
		if(waves[currentWave].loopWave): QueueEnemies()
		else: spawningEnemies = false
	else:
		nextEnemyTime = waves[currentWave].enemies[enemySpawnCounter].enemySpawnTime

func EnemyDied() -> void:
	enemyKillCount += 1

func _on_player_detect_1_body_entered(body):
	if(currentWave == 1):
		NewWave()
		$Level3/PlayerDetect1.queue_free()

func _on_player_detect_2_body_entered(body):
	if(currentWave == 4):
		NewWave()
		$Level6/PlayerDetect2.queue_free()

func _on_player_detect_3_body_entered(body):
	if(currentWave == 6):
		NewWave()
		$Level7/PlayerDetect3.queue_free()
