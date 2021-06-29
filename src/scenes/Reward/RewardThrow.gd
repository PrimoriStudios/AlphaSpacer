extends Node2D

var pCoin := preload("res://src/scenes/Reward/Coin.tscn")
var pGem := preload("res://src/scenes/Reward/Gem.tscn")

export var maxCoins: int = 3

func _ready():
	var rand = randf()
	if rand <= 0.03:
		var gem = pGem.instance()
		gem.position = position
		get_parent().add_child(gem)
	
	elif rand <= 0.75:
		for i in randi() % (maxCoins + 1):
			var coin = pCoin.instance()
			coin.position = position
			get_parent().add_child(coin)
