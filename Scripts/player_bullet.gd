extends Node2D

@export var lifetime: float = 0.4
@export var speed: float = 500
var dir: Vector2
var startingVelocity: Vector2 = Vector2.ZERO
var age: float = 0.0

func _process(delta):
	global_position += (dir * speed + startingVelocity) * delta
	age += 1.0 * delta
	if(age > lifetime):
		queue_free()
