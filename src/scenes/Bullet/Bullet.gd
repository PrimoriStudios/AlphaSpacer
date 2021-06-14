extends Area2D

var pBulletEffect := preload("res://src/scenes/Bullet/BulletEffect.tscn")

export var speed: float = 500

var _damageRate: int

func _init(damageRate: int = 1):
	_damageRate = damageRate

func _physics_process(delta):
	position.y -= speed * delta 

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	if area.is_in_group("damageable") and not area.is_in_group("dead"):
		var bulletEffect := pBulletEffect.instance()
		bulletEffect.position = position
		get_parent().add_child(bulletEffect)
		
		var cam := get_tree().current_scene.find_node("Cam", true, false)
		cam.shake(1)
	
		area.damage(_damageRate)
		queue_free()
