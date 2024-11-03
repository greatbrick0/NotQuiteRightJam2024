extends Node2D

@export var v: Vector2 = Vector2.ZERO
var ran: bool = false

func RunAway() -> void:
	if(ran): return
	ran = true
	$WendigoCry.play()
	$WendigoSprite.flip_h = true
	$Hitbox2.queue_free()
	$TooCloseArea.queue_free()
	$RunAnim.play("Run")

func NextWave() -> void:
	get_parent().NewWave()

func _process(delta):
	global_position += v * delta

func _on_hitbox_2_area_entered(area):
	RunAway()

func _on_too_close_area_body_entered(body):
	RunAway()
