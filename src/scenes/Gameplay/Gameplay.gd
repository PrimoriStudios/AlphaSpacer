extends Node

var player := preload("res://src/scenes/Player/Player.tscn")

onready var home := $HomeLayer/Home
onready var starsParticle := $Background/StarsParticle
onready var HUD := $HUDLayer/HUD
onready var spawner := $Spawner

var playerInstance

func _ready():
	get_tree().set_quit_on_go_back(false)
	Signals.connect("on_home_pressed", self, "_on_home_pressed")
	Signals.connect("on_restart_pressed", self, "_on_restart_pressed")
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		onBackPressed()
	elif what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		onBackPressed()

func onBackPressed():
	Signals.emit_signal("on_go_back_requested")

func _on_Home_start_pressed():
	start()
	
func start():
	home.visible = false
	HUD.visible = true
	starsParticle.set_emitting(true)
	spawner.start()
	playerInstance = player.instance()
	add_child(playerInstance)
	
func stop():
	home.visible = true
	HUD.visible = false
	
func reset():
	starsParticle.set_emitting(false)
	spawner.reset()
	playerInstance.queue_free()
	playerInstance = null
	
	var enemies = get_tree().get_nodes_in_group("damageable")
	for enemy in enemies:
		enemy.queue_free()
		
	var bullets = get_tree().get_nodes_in_group("bullet")
	for bullet in bullets:
		bullet.queue_free()

func _on_home_pressed():
	reset()
	stop()

func _on_restart_pressed():
	reset()
	start()
