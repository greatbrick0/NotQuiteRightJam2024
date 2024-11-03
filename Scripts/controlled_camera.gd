extends Camera2D

var bounds: Vector2
var lockNode: Node2D
var targetPos: Vector2
var prevPos: Vector2 = Vector2.ZERO
@export var cameraBehaviour: String = "lock"
@export var camOffset: float = 0
var timeSinceChange: float = 0.0

func _process(delta):
	if(cameraBehaviour == "lock"):
		targetPos = lockNode.global_position + (Vector2.RIGHT * camOffset)
	elif(cameraBehaviour == "follow"):
		targetPos.x = %Player.global_position.x + camOffset
	elif(cameraBehaviour == "ratchet"):
		if(%Player.global_position.x + camOffset > targetPos.x):
			targetPos.x = %Player.global_position.x + camOffset
	
	timeSinceChange += 1.0 * delta
	global_position = lerp(prevPos, targetPos, min(timeSinceChange, 1.0))
	global_position.x = clampf(global_position.x, bounds.x, bounds.y)

func ChangeBehaviour(newBehaviour: String, newLockNode: Node2D, newOffset: float, newBounds: Vector2) -> void:
	prevPos = global_position
	timeSinceChange = 0.0
	cameraBehaviour = newBehaviour
	if(cameraBehaviour == "lock"):
		lockNode = newLockNode
	camOffset = newOffset
	bounds = newBounds
