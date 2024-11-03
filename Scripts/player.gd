extends CharacterBody2D
class_name Player

@export var baseMoveSpeed: float = 170
@export var currentHealth: int = 3
@export var currentAmmo: int = 2
@export var gunActionCooldown: float = 0.4
@export var gunReloadCooldown: float = 1.4
var gunActionTime: float = 0
@export var lockedControls: bool = false
@export var forceWalkAnim: bool = false

var instanceRef: Node
@export var bulletScene: PackedScene
@export var healthStages: Array[SpriteFrames]

var inputMoveDir: Vector2

func _process(delta):
	var mousPos: Vector2 = get_global_mouse_position()
	if(!lockedControls):
		inputMoveDir.y = Input.get_axis("MoveUp", "MoveDown")
		inputMoveDir.x = Input.get_axis("MoveLeft", "MoveRight")
		
		if(mousPos.x > global_position.x):
			$Visuals.scale.x = 1
		elif(mousPos.x < global_position.x):
			$Visuals.scale.x = -1
		$Visuals/ShotgunCentre.look_at(get_global_mouse_position())
	
	velocity = (inputMoveDir).normalized() * baseMoveSpeed
	if(velocity.distance_squared_to(Vector2.ZERO) != 0 or forceWalkAnim):
		$Visuals/Hunter.play("walk")
	else:
		$Visuals/Hunter.play("idle")
	move_and_slide()
	
	if(gunActionTime > 0):
		gunActionTime -= 1.0 * delta
	else:
		if(currentAmmo <= 0):
			ReloadGun()
		elif(Input.is_action_pressed("Shoot") and !lockedControls):
			Shoot()
			$Visuals/ShotgunCentre/Shotgun.play()
			$Sounds/GunBlastSound.play()
			currentAmmo -= 1
			gunActionTime = gunActionCooldown

func ReloadGun() -> void:
	$Sounds/GunEmptySound.play()
	currentAmmo = 2
	gunActionTime = gunReloadCooldown

func Shoot() -> void:
	for ii in 12:
		instanceRef = bulletScene.instantiate()
		instanceRef.global_position = %BulletPoint.global_position
		instanceRef.startingVelocity = velocity
		instanceRef.dir = $Visuals/ShotgunCentre.global_position.direction_to(%BulletPoint.global_position)
		instanceRef.dir = instanceRef.dir.rotated(randf_range(-0.2, 0.2))
		instanceRef.speed *= randf_range(0.95, 1)
		get_parent().add_child(instanceRef)

func TakeDamage() -> void:
	currentHealth -= 1
	if(currentHealth <= 0):
		lockedControls = true
		$Visuals.visible = false
	else:
		$Visuals/Hunter.sprite_frames = healthStages[currentHealth-1]
	$Particles/DamageParticles.emitting = true
	$Sounds/CloakTearSound.play()

func _on_hitbox_area_entered(area):
	TakeDamage()
