extends CharacterBody2D

@export var health: int = 30
@export var moveSpeed: float = 270
var targetDirection: Vector2
var behaviourState: String = "looking"
var stateTime: float = 0.0

func DecideDirection() -> void:
	targetDirection = global_position.direction_to(%Player.global_position)

func ChangeState(newState: String):
	stateTime = 0.0
	behaviourState = newState

func _process(delta):
	stateTime += 1.0 * delta
	
	if(behaviourState == "attacking"):
		velocity = targetDirection * moveSpeed
		if(DistanceFromCamera() > 0.4 and stateTime > 0.1):
			ChangeState("looking")
	if(behaviourState == "looking"):
		velocity = Vector2.ZERO
		if(stateTime > 1.5):
			DecideDirection()
			ChangeState("attacking")
	
	move_and_slide()

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
