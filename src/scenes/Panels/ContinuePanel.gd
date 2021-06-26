extends PanelContainer

onready var progress := $MarginContainer/VBoxContainer/Countdown/Progress
onready var timeLeft := $MarginContainer/VBoxContainer/Countdown/TimeLeft
onready var timer := $Timer

export var duration: int = 5

func _ready():
	reset()

func reset():
	timeLeft.text = str(duration)
	progress.value = 100


func show():
	timer.start(duration)
	visible = true


func hide():
	timer.stop()
	visible = false
	reset()


func _process(_delta):
	if not visible or timer.is_stopped():
		return
	
	var time = timer.time_left
	progress.value = int(time * 100 / duration)
	
	if time <= 4:
		timeLeft.text = str(int(time) + 1)


func _on_CancelButton_pressed():
	hide()
	Signals.emit_signal("on_continue_cancelled")


func _on_ContinueButton_pressed():
	hide()
	Signals.emit_signal("on_continue_requested")


func _on_Timer_timeout():
	hide()
	Signals.emit_signal("on_continue_cancelled")
