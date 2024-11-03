extends Camera2D

var lockNode: Node2D
var targetPos: Vector2
var prevPos: Vector2 = Vector2.ZERO
@export var cameraBehaviour: String = "lock"
var timeSinceChange: float = 0.0

func _process(delta):
	if(cameraBehaviour == "lock"):
		targetPos = lockNode.global_position
	elif(cameraBehaviour == "follow"):
		targetPos.x = %Player.global_position.x
	elif(cameraBehaviour == "ratchet"):
		if(%Player.global_position.x > targetPos.x):
			targetPos.x = %Player.global_position.x
	
	timeSinceChange += 1.0 * delta
	global_position = lerp(prevPos, targetPos, min(timeSinceChange, 1.0))

func ChangeBehaviour(newBehaviour: String, newLockNode: Node2D = null) -> void:
	prevPos = global_position
	timeSinceChange = 0.0
	cameraBehaviour = newBehaviour
	if(cameraBehaviour == "lock"):
		lockNode = newLockNode
