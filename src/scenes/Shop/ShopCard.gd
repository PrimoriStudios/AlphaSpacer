extends PanelContainer

enum ResourceType { coins, gems }

export var id := "Card"
export(ResourceType) var resType := ResourceType.coins
export var price : float = 0.99
export var free: bool = false
export var maxAdsCount: int = 3
