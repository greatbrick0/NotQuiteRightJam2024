extends Node2D

var inputMoveDir: Vector2

func _process(delta):
	inputMoveDir.y = Input.get_axis("MoveUp", "MoveDown")
	inputMoveDir.x = Input.get_axis("MoveLeft", "MoveRight")
	global_position += (inputMoveDir).normalized() * delta * 30
