extends Area2D

class_name Player

var plBullet := preload("res://src/scenes/Bullet/Bullet.tscn")

onready var firePoses := $FiringPositions
onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibilityTimer
onready var shildSprite := $Shield
onready var bulletSound := $BulletSound

export var speed: float = 100.0
export var loadingSpeed: float = 300
export var fireDelay: float = 0.1
export var life: int = 3
export var damageInvincibilityTime : float = 2.0

var vel := Vector2(0, 0)
var remainingLife: int = life

var deltaX: float
var deltaY: float
var startingPos: Vector2

var loading = true


func _ready():
	startingPos = get_parent().get_node("StartingPos").position
	position.x = startingPos.x
	position.y = get_viewport_rect().end.y
	
	shildSprite.visible = false
	emitLifeChanged()
	fireDelayTimer.start(fireDelay)


func _input(event):
	if event is InputEventScreenTouch and event.is_pressed() and not loading:
		deltaX = event.position.x - position.x
		deltaY = event.position.y - position.y
		
	elif event is InputEventScreenDrag and not loading:
		var posX = event.position.x - deltaX
		var posY = event.position.y - deltaY
		position.x = posX
		position.y = posY


func _process(_delta):
	if loading:
		return
	
	# Check if shooting
	if fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		bulletSound.play()
		
		for child in firePoses.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)


func _physics_process(delta):
	if loading:
		onLoading(delta)
		return
	
	var dirVec := Vector2(0, 0)
	
	# Horizontal movement..
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1
		
	# Vertical Movement
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1
	
	vel = dirVec.normalized() * speed
	position += vel * delta
	
	# Keep the player within the screen
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)


func onLoading(delta):
	if (position.y <= startingPos.y):
		loading = false
		return
	
	position.y -= loadingSpeed * delta


func damage(amount: int):
	if !invincibilityTimer.is_stopped():
		return
		
	invincibilityTimer.start(damageInvincibilityTime)
	shildSprite.visible = true
	
	remainingLife -= amount
	emitLifeChanged()
	
	var cam := get_tree().current_scene.find_node("Cam", true, false)
	cam.shake(20)
	
	if remainingLife <= 0:
		queue_free()


func _on_InvincibilityTimer_timeout():
	shildSprite.visible = false


func emitLifeChanged():
	Signals.emit_signal("on_player_life_changed", life, remainingLife)
