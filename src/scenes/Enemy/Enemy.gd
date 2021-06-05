extends Area2D
class_name Enemy

var plBullet := preload("res://src/scenes/Bullet/EnemyBullet.tscn")
var plExplosion := preload("res://src/scenes/Enemy/EnemyExplosion.tscn")

onready var firePoses := $FiringPositions

export var verticalSpeed: float = 10.0
export var health: int = 5

var playerInArea: Player = null

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)

func _physics_process(delta):
	position.y += verticalSpeed * delta
	
func fire():
	for child in firePoses.get_children():
		var bullet := plBullet.instance()
		bullet.global_position = child.global_position
		get_tree().current_scene.add_child(bullet)

func damage(amount: int):
	if health <= 0:
		return
	
	health -= amount
	if health <= 0:
		var effect := plExplosion.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
		
		Signals.emit_signal("on_score_increment", 1)
		
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Enemy_area_entered(area):
	if area is Player:
		playerInArea = area


func _on_Enemy_area_exited(area):
	if area is Player:
		playerInArea = null
