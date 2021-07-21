extends Control

signal start_pressed

onready var coinCounter := $Layout/Header/Counters/CoinCounter
onready var gemCounter := $Layout/Header/Counters/GemCounter
onready var body := $Layout/Body
onready var shop := $ShopLayer/Shop
onready var bnrPadding := $Layout/BannerPadding
onready var shopBnrPadding := $ShopLayer/Shop/BannerPadding

func _ready():
	body.connect("gui_input", self, "gui_input")
	Signals.connect("on_banner_loaded", self, "_on_banner_loaded")


func gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		emit_signal("start_pressed")


func setCoins(value: int) -> void:
	coinCounter.setValue(value)


func setGems(value: int) -> void:
	gemCounter.setValue(value)


func _on_ShopButton_pressed():
	shop.visible = true


func _on_SettingsButton_pressed():
	pass # Replace with function body.


func _on_banner_loaded(dimensions: Vector2) -> void:
	bnrPadding.rect_min_size.y = dimensions.y
	shopBnrPadding.rect_min_size.y = dimensions.y
