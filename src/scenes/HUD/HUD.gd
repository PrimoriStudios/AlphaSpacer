extends Control

onready var scoreValue := $Header/VBoxContainer/Score/Value
onready var lifeCounter := $Header/VBoxContainer/Counters/LifeCounter
onready var coinCounter := $Header/VBoxContainer/Counters/CoinCounter
onready var gemCounter := $Header/VBoxContainer/Counters/GemCounter

export var scoreLength: int = 6

var score: int = 0
var coins: int = 0

func _ready():
	scoreValue.text = fixScore()
	
	Signals.connect("on_player_life_changed", self, "_on_player_life_changed")
	Signals.connect("on_score_increment", self, "_on_score_increment")

func _on_score_increment(amount: int):
	score += amount
	scoreValue.text = fixScore(str(score))

func _on_player_life_changed(life: int, remaining: int):
	lifeCounter.setValue(remaining)

func fixScore(value := "") -> String:
	if value.length() < scoreLength:
		for i in range(0, scoreLength - value.length()):
			value = "0" + value
			
	return value


func reset() -> void:
	score = 0
	coins = 0
	scoreValue.text = fixScore()


func _on_PauseButton_pressed():
	Signals.emit_signal("on_pause_clicked")
