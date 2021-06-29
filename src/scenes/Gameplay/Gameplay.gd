extends Node

var player := preload("res://src/scenes/Player/Player.tscn")
var pFiler := preload("res://src/utils/Filer.gd")
var pRewardThrow := preload("res://src/scenes/Reward/RewardThrow.tscn")

onready var home := $HomeLayer/Home
onready var bestScore := $HomeLayer/Home/Body/BestScore
onready var scoreValue := $HomeLayer/Home/Body/BestScore/Value
onready var starsParticle := $Background/StarsParticle
onready var hud := $HUDLayer/HUD
onready var spawner := $Spawner
onready var continuePanel := $PanelLayer/ContinuePanel
onready var gameOverLabel := $GameoverLayer/Label
onready var gameOverSound := $GameoverLayer/Sound
onready var pausePanel := $PauseLayer/Pause

export var saveGamePath: String

var filer: Filer
var playerInstance: Player
var defGameState = {
	"Score": 0,
	"Coins": 0,
	"Gems": 0
}
var thrower

func _ready() -> void:
	get_tree().set_quit_on_go_back(false)
	Signals.connect("on_pause_clicked", self, "_on_pause_clicked")
	Signals.connect("on_home_pressed", self, "_on_home_pressed")
	Signals.connect("on_restart_pressed", self, "_on_restart_pressed")
	Signals.connect("on_continue_requested", self, "_on_continue_requested")
	Signals.connect("on_continue_cancelled", self, "_on_continue_cancelled")
	Signals.connect("on_player_died", self, "_on_player_died")
	
	filer = pFiler.new(saveGamePath, defGameState)


func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		onBackPressed()
	elif what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		onBackPressed()


func _on_pause_clicked():
	if not continuePanel.visible:
		var newPauseState = not get_tree().paused
		get_tree().paused = newPauseState
		pausePanel.visible = newPauseState


func onBackPressed() -> void:
	Signals.emit_signal("on_go_back_requested")

func _on_Home_start_pressed() -> void:
	start()


func start() -> void:
	home.visible = false
	hud.visible = true
	starsParticle.set_emitting(true)
	spawner.start()
	playerInstance = player.instance()
	add_child(playerInstance)


func stop() -> void:
	showHome()

func showHome():
	var data = filer.read()
	var lastScore: int = data["Score"]
	
	if lastScore != 0:
		scoreValue.text = str(lastScore)
		home.setCoins(data["Coins"])
		home.setGems(data["Gems"])
		
		if not bestScore.visible:
			bestScore.visible = true
	
	home.visible = true


func saveState() -> void:
	var data = filer.read()
	var cScore = data["Score"]
	
	if hud.score > cScore:
		cScore = hud.score
	
	filer.save({
		"Score": cScore,
		"Coins": data["Coins"] + hud.coins,
		"Gems": data["Gems"] + hud.gems
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
	
	saveState()
	hud.reset()


func gameover():
	reset()
	hud.visible = false
	gameOverLabel.visible = true
	gameOverSound.play()


func _on_home_pressed() -> void:
	reset()
	hud.visible = false
	stop()


func _on_restart_pressed() -> void:
	reset()
	start()


func _on_continue_requested() -> void:
	playerInstance.restore()


func _on_continue_cancelled() -> void:
	gameover()


func _on_player_died() -> void:
	continuePanel.show()


func _on_GamoverSound_finished():
	gameOverLabel.visible = false
	stop()
