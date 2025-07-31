extends Node2D

@export var seed: PackedScene

func _input(event):
	# If "spacebar" is pressed (set in Project Settings > Input Map)
	if event.is_action_pressed("drop"):
		var new_seed_instance = seed.instantiate()
		get_parent().add_child(new_seed_instance)
		new_seed_instance.transform = self.global_transform
