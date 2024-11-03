extends Camera2D

var lockNode: Node2D
var targetPos: Vector2
var prevPos: Vector2 = Vector2.ZERO
var cameraBehaviour: String = "lock"

func _process(delta):
	if(cameraBehaviour == "lock"):
		targetPos = lockNode.global_position
	elif(cameraBehaviour == "follow"):
		targetPos.x = %Player.global_position.x
	elif(cameraBehaviour == "ratchet"):
		if(%Player.global_position.x > targetPos.x):
			targetPos.x = %Player.global_position.x

func ChangeBehaviour(newBehaviour: String, newLockNode: Node2D = null) -> void:
	prevPos = targetPos
	cameraBehaviour = newBehaviour
	if(cameraBehaviour == "lock"):
		lockNode = newLockNode
