extends Node2D

var pCoin := preload("res://src/scenes/Reward/Coin.tscn")
var pGem := preload("res://src/scenes/Reward/Gem.tscn")

func _ready():
	var rand = randf()
	if rand <= 0.03:
		var gem = pGem.instance()
		gem.position = position
		get_parent().add_child(gem)
	
	elif rand <= 0.75:
		var maxCount: int = 1
		
		if rand <= 0.25:
			maxCount = 3
		elif rand <= 0.50:
			maxCount <= 2

		for i in maxCount:
			var coin = pCoin.instance()
			coin.position = position
			get_parent().add_child(coin)
