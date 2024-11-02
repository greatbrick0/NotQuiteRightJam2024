extends CharacterBody2D

@export var baseMoveSpeed: float = 170

@export var bulletScene: PackedScene

var inputMoveDir: Vector2

func _process(delta):
	inputMoveDir.y = Input.get_axis("MoveUp", "MoveDown")
	inputMoveDir.x = Input.get_axis("MoveLeft", "MoveRight")
	
	var mousPos: Vector2 = get_global_mouse_position()
	if(mousPos.x > global_position.x):
		$Visuals.scale.x = 1
	elif(mousPos.x < global_position.x):
		$Visuals.scale.x = -1
	$Visuals/ShotgunCentre.look_at(get_global_mouse_position())
	
	velocity = (inputMoveDir).normalized() * baseMoveSpeed
	move_and_slide()
	
	if(Input.is_action_pressed("Shoot")):
		Shoot()

func Shoot() -> void:
	pass
