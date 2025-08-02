extends CPUParticles2D

func _ready():
	self.emitting = true # Stop emitting new particles
	self.one_shot = true   # Ensure particles finish their animation
	self.finished.connect(_on_particles_finished)

func _on_particles_finished():
	queue_free()
