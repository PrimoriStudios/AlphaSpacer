extends Enemy

export var rotationRate: int = 360

export var minHSpeed: float = 1080.0
export var maxHSpeed: float = 1600.0

export var minVSpeed: float = 300.0
export var maxVSpeed: float = 400.0

var hDirection: int = 1
var hSpeed: float
var vSpeed: float

func _ready():
	randomize()
	hSpeed = rand_range(minHSpeed, maxHSpeed)
	vSpeed = rand_range(minVSpeed, maxVSpeed)


func _physics_process(delta):
	rotate(deg2rad(rotationRate) * delta)
	
	position.x += hSpeed * delta * hDirection
	position.y += vSpeed * delta

	var viewRect := get_viewport_rect()
	if position.x < viewRect.position.x or position.x > viewRect.end.x:
		hDirection *= -1
