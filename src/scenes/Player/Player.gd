extends Area2D

class_name Player

var plBullet := preload("res://src/scenes/Bullet/Bullet.tscn")

onready var sprite := $AnimatedSprite
onready var firePoses := $FiringPositions
onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibilityTimer
onready var shildSprite := $Shield

export var speed: float = 100.0
export var fireDelay: float = 0.1
export var life: int = 3
export var damageInvincibilityTime : float = 2.0
var vel := Vector2(0, 0)

func _ready():
	shildSprite.visible = false
	emitLifeChanged()

func _process(_delta):
	if vel.x < 0:
		sprite.play("left")
	elif vel.x > 0:
		sprite.play("right")
	else:
		sprite.play("straight")
		
	# Check if shooting
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		
		for child in firePoses.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)
	
func _physics_process(delta):
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

func damage(amount: int):
	if !invincibilityTimer.is_stopped():
		return
		
	invincibilityTimer.start(damageInvincibilityTime)
	shildSprite.visible = true
	
	life -= amount
	emitLifeChanged()
	
	var cam := get_tree().current_scene.find_node("Cam", true, false)
	cam.shake(20)
	
	if life <= 0:
		queue_free()

func _on_InvincibilityTimer_timeout():
	shildSprite.visible = false

func emitLifeChanged():
	Signals.emit_signal("on_player_life_changed", life)
