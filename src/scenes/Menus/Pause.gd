extends Control

func _ready():
	visible = false
	Signals.connect("on_pause_clicked", self, "_on_pause_clicked")
	Signals.connect("on_go_back_requested", self, "_on_go_back_requested")

func _on_pause_clicked():
	var newPauseState = not get_tree().paused
	get_tree().paused = newPauseState
	
	visible = newPauseState

func _on_go_back_requested():
	if visible == true:
		_on_Resume_pressed()
		
func hide():
	visible = false
	get_tree().paused = false

func _on_Resume_pressed():
	hide()
	
func _on_Home_pressed():
	hide()
	Signals.emit_signal("on_home_pressed")

func _on_Restart_pressed():
	hide()
	Signals.emit_signal("on_restart_pressed")
