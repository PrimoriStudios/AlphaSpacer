extends Area2D
class_name Meteor

var pMeteorEffect := preload("res://src/scenes/Meteor/MeteorEffect.tscn")

export var minSpeed: float = 10
export var maxSpeed: float = 20
export var minRotationRate: float = -10
export var maxRotationRate: float = 10

export var life: int = 20
export var score: int = 40

var speed: float = 0.0
var rotationRate: float = 0
var playerInArea: Player = null

func _ready():
	speed = rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)
	
func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)
	
func _physics_process(delta):
	rotation_degrees += rotationRate * delta
	
	position.y += speed * delta

func damage(amount: int):
	if life <= 0:
		return
	
	life -= amount
	if life <= 0:
		var effect :=pMeteorEffect.instance()
		effect.position = position
		get_parent().add_child(effect)
		
		Signals.emit_signal("on_score_increment", score)
		
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Meteor_area_entered(area):
	if area is Player:
		playerInArea = area


func _on_Meteor_area_exited(area):
	if area is Player:
		playerInArea = null
