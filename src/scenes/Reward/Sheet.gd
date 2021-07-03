extends Area2D

onready var sprite := $AnimatedSprite

export var fallSpeed: int = 0

var sheetTypes := [ "power", "shield", "health" ]
var selected: String

func _ready():
	selected = sheetTypes[randi() % sheetTypes.size()]
	sprite.set_animation(selected)


func _on_Sheet_area_entered(area):
	if area is Player:
		area.catchSheet(selected)
		queue_free()


func _physics_process(delta):
	position.y += fallSpeed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
