extends VBoxContainer

signal start_pressed

func _ready():
	$Body.connect("gui_input", self, "gui_input")
	
func gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		emit_signal("start_pressed")
