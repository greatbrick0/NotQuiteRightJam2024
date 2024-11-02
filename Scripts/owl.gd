extends CharacterBody2D

@export var health: int = 30
@export var moveSpeed: float = 270
var targetDirection: Vector2
var behaviourState: String = "looking"
var stateTime: float = 0.0

var instanceRef: Node
@export var scratchScene: PackedScene

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
	if(global_position.distance_to(%Player.global_position) < 30):
		instanceRef = scratchScene.instantiate()
		instanceRef.global_position = %Player.global_position
		get_parent().add_child(instanceRef)
		%Player.TakeDamage()
		targetDirection = -1 * global_position.direction_to(%Player.global_position)
		ChangeState("retreating")
	if(DistanceFromCamera() > 0.45 and stateTime > 0.1):
		ChangeState("looking")

func Retreating() -> void:
	velocity = targetDirection * moveSpeed * 0.7
	if(DistanceFromCamera() > 0.3 and stateTime > 0.1):
		if(global_position.distance_to(%Player.global_position) > 200 or DistanceFromCamera() > 0.45):
			ChangeState("looking")

func Looking() -> void:
	velocity = Vector2.ZERO
	if(%Player.global_position > global_position):
		$Visuals.scale.x = -1
	elif(%Player.global_position < global_position):
		$Visuals.scale.x = 1
	if(stateTime > 1.5):
		targetDirection = global_position.direction_to(%Player.global_position)
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
		queue_free()