extends PanelContainer

onready var valueLabel := $MarginContainer/HBoxContainer/Value
onready var animPlayer := $AnimationPlayer

func setValue(value: int) -> void:
	valueLabel.text = str(value)
	
	if not animPlayer.is_playing():
		animPlayer.play("scale")
