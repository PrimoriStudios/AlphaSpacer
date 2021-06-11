extends Enemy
class_name SlowShooterEnemy

onready var fireTimer := $FireTimer

export var fireRate: float = 1.0

func _process(delta):
	if fireTimer.is_stopped():
		fire()
		fireTimer.start(fireRate)
