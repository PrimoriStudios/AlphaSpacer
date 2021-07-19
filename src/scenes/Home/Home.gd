extends VBoxContainer

signal start_pressed

onready var coinCounter := $Header/Counters/CoinCounter
onready var gemCounter := $Header/Counters/GemCounter

func _ready():
	$Body.connect("gui_input", self, "gui_input")


func gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		emit_signal("start_pressed")


func setCoins(value: int) -> void:
	coinCounter.setValue(value)


func setGems(value: int) -> void:
	gemCounter.setValue(value)


func _on_ShopButton_pressed():
	pass # Replace with function body.


func _on_SettingsButton_pressed():
	pass # Replace with function body.
