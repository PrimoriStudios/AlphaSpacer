extends Area2D

class_name Player

var pBullet := preload("res://src/scenes/Bullet/Bullet.tscn")
var pBulletEffect := preload("res://src/scenes/Bullet/BulletEffect.tscn")

onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibilityTimer
onready var shildSprite := $Shield
onready var hitSound := $HitSound
onready var bulletSound := $BulletSound
onready var explosionSound := $ExplosionSound
onready var collision := $CollisionPolygon2D
onready var anims := $AnimationPlayer
onready var upgradeSound := $UpgradeSound
onready var rewardSound := $RewardSound

export var speed: float = 100.0
export var loadingSpeed: float = 300
export var fireDelay: float = 0.1
export var life: int = 3
export var damageInvincibilityTime : float = 2.0
export var shieldTime: float = 10.0
export(int, 1, 3) var initialGunLevel: int = 1

var vel := Vector2(0, 0)
var remainingLife: int = life

var deltaX: float
var deltaY: float
var startingPos: Vector2

var died: bool = false
var loading: bool = true
var effectAnims
var cam
var gunsLevel: int
var guns

func _ready():
	startingPos = get_parent().get_node("StartingPos").position
	position.x = startingPos.x
	position.y = get_viewport_rect().end.y
	
	var root = get_tree().get_root()
	effectAnims = root.get_node("Gameplay/EffectLayer/AnimationPlayer")
	cam = root.get_node("Gameplay/Cam")
	
	shildSprite.visible = false
	emitLifeChanged()
	fireDelayTimer.start(fireDelay)
	gunsLevel = initialGunLevel
	configureGuns()


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
	if loading or died:
		return
	
	# Check if shooting
	if fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		bulletSound.play()
		
		for child in guns:
			var bullet := pBullet.instance()
			var effect := pBulletEffect.instance()
			var cScene := get_tree().current_scene
			
			bullet.global_position = child.global_position
			effect.global_position = child.global_position
			
			cScene.add_child(bullet)
			cScene.add_child(effect)


func configureGuns() -> void:
	if gunsLevel == 1:
		guns = [ $FiringPositions/MiddleGun ]
	elif gunsLevel == 2:
		guns = [
			$FiringPositions/LeftGun,
			$FiringPositions/RightGun
		]
	elif gunsLevel == 3:
		guns = [
			$FiringPositions/LeftGun,
			$FiringPositions/MiddleGun,
			$FiringPositions/RightGun
		]


func _physics_process(delta):
	if died: return
	
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
	if !invincibilityTimer.is_stopped() or died:
		return
		
	invincibilityTimer.start(damageInvincibilityTime)
	shildSprite.visible = true
	
	remainingLife -= amount
	emitLifeChanged()
	
	cam.shake(20)
	effectAnims.play("damage")
	
	if remainingLife <= 0:
		die()
	else:
		hitSound.play()
		anims.play("damage")


func die():
	died = true
	collision.disabled = true
	visible = false
	explosionSound.play()
	Signals.emit_signal("on_player_died")


func restore():
	died = false
	collision.disabled = false
	visible = true
	remainingLife += 1
	emitLifeChanged()
	effectAnims.play("upgrade")
	upgradeSound.play()


func catchSheet(type: String) -> void:
	var playSound := true
	
	if type == "health":
		if remainingLife < life:
			remainingLife += 1
			emitLifeChanged()
	
	elif type == "power":
		if gunsLevel < 3:
			gunsLevel += 1
			configureGuns()
	
	elif type == "shield":
		invincibilityTimer.start(shieldTime)
		shildSprite.visible = true
	
	else:
		playSound = false
	
	if playSound:
		effectAnims.play("upgrade")
		upgradeSound.play()


func _on_InvincibilityTimer_timeout():
	shildSprite.visible = false


func emitLifeChanged():
	Signals.emit_signal("on_player_life_changed", life, remainingLife)


func _on_Player_body_entered(body):
	if (body is Coin or body is Gem) and not died:
		body.reward()
		rewardSound.play()
