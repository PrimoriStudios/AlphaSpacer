extends RigidBody2D

class_name Coin

var absHVel: float = 50.0
var minUpVel: float = 300.0
var maxUpVel: float = 400.0

var lastHeight: float

func _ready():
	randomize()
	linear_velocity.x = rand_range(-absHVel, absHVel)
	linear_velocity.y = -rand_range(minUpVel, maxUpVel)
	
	if linear_velocity.x < 0:
		angular_velocity *= -1


func _process(delta):
	if position.y > lastHeight:
		gravity_scale += 0.1
	
	lastHeight = position.y


func reward():
	Signals.emit_signal("on_coin_catched")
	queue_free()
