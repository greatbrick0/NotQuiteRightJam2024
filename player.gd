extends CharacterBody2D

@export var baseMoveSpeed = 100

var inputMoveDir: Vector2

func _process(delta):
	inputMoveDir.y = Input.get_axis("MoveUp", "MoveDown")
	inputMoveDir.x = Input.get_axis("MoveLeft", "MoveRight")
	#global_position += (inputMoveDir).normalized() * delta * baseMoveSpeed
	velocity = (inputMoveDir).normalized() * baseMoveSpeed
	move_and_slide()
