extends Node2D

onready var valueLabel := $Value
onready var animPlayer := $AnimationPlayer

var value: int

func _ready() -> void:
	valueLabel.text = "+" + str(value)
	valueLabel.visible = true
	animPlayer.play("scale")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
