extends VBoxContainer

onready var scroll := $Body/Scroll

var swiping = false
var swipe_start
var swipe_mouse_start
var swipe_mouse_times = []
var swipe_mouse_positions = []

var payment

func _ready():
	Signals.connect("on_purchase_requested", self, "_on_purchase_requested")
	
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		
		# These are all signals supported by the API
		# You can drop some of these based on your needs
		
		# Fired when connected
		payment.connect("connected", self, "_on_connected") # No params
		# Fired when disconnected
		payment.connect("disconnected", self, "_on_disconnected") # No params
		# Fired when can't connect
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		# Fired when you get your purchases
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		# Fired when you can't get your purchases
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		# Fired when you get your sku details
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		# fired when you can't get your sku details
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		# Fired when you purchase something
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		# Fired when you can't purchase something
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		# Fired when you use an item
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		# Fired when you can use an item
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)

#		payment.startConnection()


func _on_connected():
	var packs = get_tree().get_nodes_in_group("resource_pack")
	var ids = []
	
	for pack in packs:
		ids.append((pack as ShopCard).get_id())
	
	payment.querySkuDetails(ids, "inapp")


func _on_purchase_requested(pack: ShopCard) -> void:
	var response = payment.purchase(pack.get_id())
	if response.status != OK:
		print("[" + response.status + "] Error purchasing item: " + pack.get_id())


func _purchases_updated(items):
	for item in items:
		if item.is_acknowledged:
			payment.acknowledgePurchase(item.purchase_token)
	
	if items.size() > 0:
		var token = items[items.size() - 1].purchase_token
		if token != null:
			payment.consumePurchase(token)
		else:
			print("Could not use the item with token: " + token)


func _on_Button_pressed():
	set_visible(false)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			swiping = true
			swipe_start = Vector2(scroll.get_h_scroll(), scroll.get_v_scroll())
			swipe_mouse_start = event.position
			swipe_mouse_times = [OS.get_ticks_msec()]
			swipe_mouse_positions = [swipe_mouse_start]
		
		else:
			swipe_mouse_times.append(OS.get_ticks_msec())
			swipe_mouse_positions.append(event.position)
			var source = Vector2(scroll.get_h_scroll(), scroll.get_v_scroll())
			var idx = swipe_mouse_times.size() - 1
			var now = OS.get_ticks_msec()
			var cutoff = now - 100
			for i in range(swipe_mouse_times.size() - 1, -1, -1):
				if swipe_mouse_times[i] >= cutoff: idx = i
				else: break
			var flick_start = swipe_mouse_positions[idx]
			var flick_dur = min(0.3, (event.position - flick_start).length() / 1000)
			
			if flick_dur > 0.0:
				var tween = Tween.new()
				add_child(tween)
				var delta = event.position - flick_start
				var target = source - delta * flick_dur * 15.0
				tween.interpolate_method(self, 'set_h_scroll', source.x, target.x, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.interpolate_method(self, 'set_v_scroll', source.y, target.y, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.interpolate_callback(tween, flick_dur, 'queue_free')
				tween.start()
			
			swiping = false
		
	elif swiping and event is InputEventMouseMotion:
		var delta = event.position - swipe_mouse_start
		scroll.set_h_scroll(swipe_start.x - delta.x)
		scroll.set_v_scroll(swipe_start.y - delta.y)
		swipe_mouse_times.append(OS.get_ticks_msec())
		swipe_mouse_positions.append(event.position)
