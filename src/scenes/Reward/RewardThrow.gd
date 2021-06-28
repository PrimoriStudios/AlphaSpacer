extends Node2D

var pCoin := preload("res://src/scenes/Reward/Coin.tscn")

export var maxCoins: int = 3

func _ready():
	var coin = pCoin.instance()
	coin.position = position
	add_child(coin)
