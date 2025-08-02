extends Sprite2D

@onready var parent = get_parent() as PathFollow2D

func _ready():
	parent.progress_ratio = randf()

func _physics_process(delta):
	if parent is PathFollow2D:
		parent.set_progress(parent.get_progress() + 20 * delta)
		
