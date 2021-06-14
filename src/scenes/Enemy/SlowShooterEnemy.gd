extends Enemy
class_name SlowShooterEnemy

onready var fireTimer := $FireTimer
onready var bulletSound := $BulletSound

export var fireRate: float = 1.0

func _process(delta):
	if fireTimer.is_stopped() and not is_in_group("dead"):
		fire()
		bulletSound.play()
		fireTimer.start(fireRate)
