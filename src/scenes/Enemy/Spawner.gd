extends Node2D

var pEnemies := [
	preload("res://src/scenes/Enemy/FastEnemy.tscn"),
	preload("res://src/scenes/Enemy/SlowShooterEnemy.tscn"),
	preload("res://src/scenes/Enemy/BouncerEnemy.tscn")
]

var pMeteor := preload("res://src/scenes/Meteor/Meteor.tscn")

onready var spawnTimer := $SpawnTimer

export var minSpawnTime = 1.5

var nextSpawnTime: float = 5.0

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)


func _on_SpawnTimer_timeout():
	var viewRect := get_viewport_rect()
	var xPos := rand_range(viewRect.position.x, viewRect.end.x)
	var pos := Vector2(xPos, position.y)
	
	if randf() <= 0.1:
		var meteor: Meteor = pMeteor.instance()
		meteor.position = pos
		get_tree().current_scene.add_child(meteor)
		
	else:
		var enemyPreload = pEnemies[randi() % pEnemies.size()]
		var enemy: Enemy = enemyPreload.instance()
		
		enemy.position = pos
		get_tree().current_scene.add_child(enemy)
	
	nextSpawnTime -= 0.1
	if nextSpawnTime < minSpawnTime:
		nextSpawnTime = minSpawnTime
		
	spawnTimer.start(nextSpawnTime)
