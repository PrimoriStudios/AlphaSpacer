extends Area2D
class_name Enemy

var plBullet := preload("res://src/scenes/Bullet/EnemyBullet.tscn")
var plExplosion := preload("res://src/scenes/Enemy/EnemyExplosion.tscn")
var pBulletEffect := preload("res://src/scenes/Bullet/EnemyBulletEffect.tscn")

onready var firePoses := $FiringPositions
onready var anims := $AnimationPlayer
onready var damageSound := $DamageSound

export var verticalSpeed: float = 10.0
export var health: int = 5
export var scores: int = 70

var isDead = false
var playerInArea: Player = null

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)

func _physics_process(delta):
	position.y += verticalSpeed * delta
	
func fire():
	for child in firePoses.get_children():
		var bullet := plBullet.instance()
		var effect := pBulletEffect.instance()
		var cScene := get_tree().current_scene
		
		bullet.global_position = child.global_position
		effect.global_position = child.global_position
		
		cScene.add_child(bullet)
		cScene.add_child(effect)

func damage(amount: int):
	if health <= 0:
		return
	
	health -= amount
	if health <= 0:
		var effect := plExplosion.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
		
		Signals.emit_signal("on_score_increment", scores)
		died()
	elif not anims.is_playing():
		anims.play("damage")
		damageSound.play()


func died():
	visible = false
	$ExplosionSound.play()
	add_to_group("dead")
	isDead = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Enemy_area_entered(area):
	if area is Player and not isDead:
		playerInArea = area

func _on_Enemy_area_exited(area):
	if area is Player and not isDead:
		playerInArea = null

func _on_ExplosionSound_finished():
		queue_free()
