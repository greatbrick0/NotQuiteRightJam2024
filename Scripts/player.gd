extends CharacterBody2D

@export var baseMoveSpeed: float = 170
@export var currentAmmo: int = 2
@export var gunActionCooldown: float = 0.4
@export var gunReloadCooldown: float = 1.4
var gunActionTime: float = 0

var instanceRef: Node
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
	
	if(gunActionTime > 0):
		gunActionTime -= 1.0 * delta
	else:
		if(Input.is_action_pressed("Shoot")):
			if(currentAmmo > 0):
				Shoot()
				$Sounds/GunBlastSound.play()
				currentAmmo -= 1
				gunActionTime = gunActionCooldown
			else:
				currentAmmo = 2
				gunActionTime = gunReloadCooldown

func Shoot() -> void:
	instanceRef = bulletScene.instantiate()
	instanceRef.global_position = %BulletPoint.global_position
	get_parent().add_child(instanceRef)
