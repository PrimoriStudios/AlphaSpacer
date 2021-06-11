extends Control

onready var scoreValue := $Header/LeftSection/Score/Value
onready var lifeBar := $Header/LeftSection/LifeBar/Bar

export var scoreLength: int = 6

var score: int = 0

func _ready():
	scoreValue.text = fixScore()
	
	Signals.connect("on_player_life_changed", self, "_on_player_life_changed")
	Signals.connect("on_score_increment", self, "_on_score_increment")

func setLives(life: int):
	lifeBar.value = life

func _on_score_increment(amount: int):
	score += amount
	scoreValue.text = fixScore(str(score))

func _on_player_life_changed(life: int, remaining: int):
	var value := int(remaining * 100 / life)
	setLives(value)

func fixScore(value := ""):
	if value.length() < scoreLength:
		for i in range(0, scoreLength - value.length()):
			value = "0" + value
			
	return value
