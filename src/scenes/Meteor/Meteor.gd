extends Area2D

class_name Meteor

var pSheet := preload("res://src/scenes/Reward/Sheet.tscn")
var pExplosion := preload("res://src/scenes/Effects/Explosion.tscn")
var pFloatingScore := preload("res://src/scenes/Effects/FloatingScore.tscn")

export var minSpeed: float = 10
export var maxSpeed: float = 20
export var minRotationRate: float = -10
export var maxRotationRate: float = 10

export var life: int = 20
export var score: int = 40

onready var damageSound := $DamageSound
onready var animPlayer := $AnimationPlayer

var speed: float = 0.0
var rotationRate: float = 0
var playerInArea: Player = null
var isDead := false

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
		Signals.emit_signal("on_score_increment", score)
		explode()
	else:
		animPlayer.play("damage")
		if not damageSound.is_playing():
			damageSound.stop()
		
		damageSound.play()


func explode():
	var cScene = get_tree().current_scene
	
	var effect := pExplosion.instance()
	effect.global_position = global_position
	cScene.add_child(effect)
	 
	if randf() <= 0.25:
		var sheet  := pSheet.instance()
		sheet.global_position = global_position
		cScene.add_child(sheet)
	
	var fScore := pFloatingScore.instance()
	fScore.global_position = global_position
	fScore.value = score
	cScene.add_child(fScore)
	
	visible = false
	$ExplosionSound.play()
	add_to_group("dead")
	isDead = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Meteor_area_entered(area):
	if area is Player and not isDead:
		playerInArea = area


func _on_Meteor_area_exited(area):
	if area is Player and not isDead:
		playerInArea = null


func _on_ExplosionSound_finished():
	queue_free()
