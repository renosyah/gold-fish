extends CPUParticles2D
onready var timer = $Timer

func display():
	timer.start()
	emitting = true

func is_emitting():
	return not timer.is_stopped()
