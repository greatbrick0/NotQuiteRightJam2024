extends CharacterBody2D

@export var health: int = 60
@export var moveSpeed: float = 170
var dead: bool = false
var playerRef: Player
var targetDirection: Vector2
var behaviourState: String = "looking"
var stateTime: float = 0.0

var instanceRef: Node
@export var scratchScene: PackedScene
@export var deathScene: PackedScene

func _ready():
	$Visuals/AnimatedSprite2D.play("idle")
	$Sounds/CrySound.play()

func ChangeState(newState: String):
	stateTime = 0.0
	behaviourState = newState

func _process(delta):
	stateTime += 1.0 * delta
	if(Input.is_action_just_pressed("KillButton")): Die()
	
	if(behaviourState == "attacking"):
		Attacking()
	elif(behaviourState == "retreating"):
		Retreating()
	elif(behaviourState == "looking"):
		Looking()
	
	move_and_slide()

func Attacking() -> void:
	velocity = targetDirection * moveSpeed
	if(global_position.distance_to(playerRef.global_position) < 90):
		instanceRef = scratchScene.instantiate()
		instanceRef.global_position = playerRef.global_position
		instanceRef.get_node("Visuals").scale.x = $Visuals.scale.x
		get_parent().add_child(instanceRef)
		targetDirection = -1 * global_position.direction_to(playerRef.global_position)
		$Visuals/AnimatedSprite2D.frame = 0
		$Visuals/AnimatedSprite2D.play("idle")
		ChangeState("retreating")
	if(stateTime > 0.8):
		ChangeState("looking")

func Retreating() -> void:
	velocity = Vector2.ZERO
	if(stateTime > 1.4):
		ChangeState("looking")

func Looking() -> void:
	velocity = Vector2.ZERO
	if(playerRef.global_position > global_position):
		$Visuals.scale.x = -1
	elif(playerRef.global_position < global_position):
		$Visuals.scale.x = 1
	if(stateTime > 0.1):
		targetDirection = global_position.direction_to(playerRef.global_position)
		$Visuals/AnimatedSprite2D.play("run")
		ChangeState("attacking")

func DistanceFromCamera() -> float:
	var output: float
	var cam: Camera2D = get_viewport().get_camera_2d()
	output = abs(global_position.x - cam.global_position.x) / (912 * cam.zoom.x)
	output = max(abs(global_position.y - cam.global_position.y) / (666 * cam.zoom.y), output)
	return output

func _on_hitbox_area_entered(area):
	health -= 1
	$Particles/DamageParticles.emitting = true
	if(health % 50 == 0):
		$Sounds/CrySound.play()
	if(health <= 0 and !dead):
		Die()

func Die() -> void:
	dead = true
	instanceRef = deathScene.instantiate()
	instanceRef.global_position = global_position
	instanceRef.get_node("Visuals").scale.x = $Visuals.scale.x
	get_parent().add_child(instanceRef)
	get_parent().EnemyDied()
	queue_free()
