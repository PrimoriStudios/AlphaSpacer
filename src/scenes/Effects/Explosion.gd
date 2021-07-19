extends CPUParticles2D


func _ready():
	emitting = true
	$Shards.emitting = true
	$BackSmoke.emitting = true
	$FrontSmoke.emitting = true


func _on_Timer_timeout():
	queue_free()
