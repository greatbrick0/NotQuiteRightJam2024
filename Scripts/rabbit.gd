extends CharacterBody2D

@export var health: int = 48
@export var moveSpeed: float = 150
var targetDirection: Vector2
var behaviourState: String = "looking"
var stateTime: float = 0.0

var instanceRef: Node
@export var scratchScene: PackedScene
@export var deathScene: PackedScene

func ChangeState(newState: String):
	stateTime = 0.0
	behaviourState = newState

func _process(delta):
	stateTime += 1.0 * delta
	
	if(behaviourState == "attacking"):
		Attacking()
	elif(behaviourState == "retreating"):
		Retreating()
	elif(behaviourState == "looking"):
		Looking()
	
	move_and_slide()

func Attacking() -> void:
	velocity = targetDirection * moveSpeed
	if(global_position.distance_to(%Player.global_position) < 60):
		print("intantiate")
		instanceRef = scratchScene.instantiate()
		instanceRef.global_position = %Player.global_position
		instanceRef.get_node("Visuals").scale.x = $Visuals.scale.x
		get_parent().add_child(instanceRef)
		%Player.TakeDamage()
		targetDirection = -1 * global_position.direction_to(%Player.global_position)
		if(%Player.global_position > global_position):
			$Visuals.scale.x = 1
		elif(%Player.global_position < global_position):
			$Visuals.scale.x = -1
		$Visuals/AnimatedSprite2D.frame = 0
		$Visuals/AnimatedSprite2D.play()
		ChangeState("retreating")
	if(stateTime > 0.8):
		ChangeState("looking")

func Retreating() -> void:
	velocity = targetDirection * moveSpeed * 1.6
	if(stateTime > 0.8):
		ChangeState("looking")

func Looking() -> void:
	velocity = Vector2.ZERO
	if(%Player.global_position > global_position):
		$Visuals.scale.x = -1
	elif(%Player.global_position < global_position):
		$Visuals.scale.x = 1
	if(stateTime > 0.7):
		targetDirection = global_position.direction_to(%Player.global_position)
		$Visuals/AnimatedSprite2D.play()
		ChangeState("attacking")

func DistanceFromCamera() -> float:
	var output: float
	var cam: Camera2D = get_viewport().get_camera_2d()
	output = abs(global_position.x - cam.global_position.x) / (912 * cam.zoom.x)
	output = max(abs(global_position.y - cam.global_position.y) / (666 * cam.zoom.y), output)
	return output

func _on_hitbox_area_entered(area):
	health -= 1
	if(health <= 0):
		instanceRef = deathScene.instantiate()
		instanceRef.global_position = global_position
		instanceRef.get_node("Visuals").scale.x = $Visuals.scale.x
		get_parent().add_child(instanceRef)
		queue_free()
