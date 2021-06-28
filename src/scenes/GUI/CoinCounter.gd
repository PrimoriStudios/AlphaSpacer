extends PanelContainer

onready var valueLabel := $MarginContainer/HBoxContainer/Value

func setValue(value: int) -> void:
	valueLabel.text = str(value)
