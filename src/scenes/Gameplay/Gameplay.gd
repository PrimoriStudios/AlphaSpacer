extends Node

var player := preload("res://src/scenes/Player/Player.tscn")
var pFiler := preload("res://src/utils/Filer.gd")

onready var home := $HomeLayer/Home
onready var bestScore := $HomeLayer/Home/Body/BestScore
onready var scoreValue := $HomeLayer/Home/Body/BestScore/Value
onready var starsParticle := $Background/StarsParticle
onready var hud := $HUDLayer/HUD
onready var spawner := $Spawner

export var saveGamePath: String

var filer: Filer
var playerInstance: Player
var defGameState = {
	"Score": 0,
	"Coins": 0
}


func _ready() -> void:
	get_tree().set_quit_on_go_back(false)
	Signals.connect("on_home_pressed", self, "_on_home_pressed")
	Signals.connect("on_restart_pressed", self, "_on_restart_pressed")
	
	filer = pFiler.new(saveGamePath, defGameState)


func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		onBackPressed()
	elif what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		onBackPressed()


func onBackPressed() -> void:
	Signals.emit_signal("on_go_back_requested")

func _on_Home_start_pressed() -> void:
	start()


func start() -> void:
	var data = filer.read()
	var lastScore: int = data["Score"]
	
	if lastScore != 0:
		scoreValue.text = str(lastScore)
		if not bestScore.visible:
			bestScore.visible = true
	
	home.visible = false
	hud.visible = true
	starsParticle.set_emitting(true)
	spawner.start()
	playerInstance = player.instance()
	add_child(playerInstance)


func stop() -> void:
	home.visible = true
	hud.visible = false
	saveState()


func saveState() -> void:
	var data = filer.read()
	
	var score = data["Score"]
	if hud.score > score:
		hud.score
	
	filer.save({
		"Score": score,
		"Coins": data["Coins"] + hud.coins
	})

func reset() -> void:
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


func _on_home_pressed() -> void:
	reset()
	stop()


func _on_restart_pressed() -> void:
	reset()
	start()
