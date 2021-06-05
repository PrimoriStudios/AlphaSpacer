extends Camera2D

export var shakeBaseAmount: float = 1.0
export var shakeDampining: float = 0.075

var shakeAmount: float = 0.0

func _process(delta):
	if shakeAmount > 0:
		position.x = rand_range(-shakeBaseAmount, shakeBaseAmount) * shakeAmount
		position.y = rand_range(-shakeBaseAmount, shakeBaseAmount) * shakeAmount
		shakeAmount = lerp(shakeAmount, 0.0, shakeDampining)
	else:
		position = Vector2(0, 0)
	
func shake(mag: float):
	shakeAmount += mag
