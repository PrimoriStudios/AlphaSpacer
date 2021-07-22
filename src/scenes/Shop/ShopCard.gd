extends PanelContainer

class_name ShopCard

enum ResourceType { coins, gems }

export var id := "Card" setget ,get_id
export(ResourceType) var resType := ResourceType.coins
export var price : float = 0.99
export var free: bool = false
export var maxAdsCount: int = 3


func get_id() -> String:
	return id


func _on_BuyButton_pressed():
	Signals.emit_signal("on_purchase_requested", self)
