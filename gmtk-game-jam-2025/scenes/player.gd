extends Node2D

@export var seed: PackedScene

@export_range(1, 10, 1, "or_greater")
var ranged_var: int = 5

func _physics_process(delta):
	# Follow mouse, don't change y value
	# Determine if using mouse of keyboarda
	# # If pressing left/right, use keyboard controls. If moving mouse, use mouse controls
	# Could lerp this!
	# self.position.x = get_viewport().get_mouse_position().x
	
	if Input.is_action_pressed("left"):
		#do stuff
		self.position.x -= ranged_var
		
	if Input.is_action_pressed('right'):
		#do stuff
		self.position.x += ranged_var
	
	pass

func _input(event):
	# If "spacebar" is pressed (set in Project Settings > Input Map)
	if event.is_action_pressed("drop"):
		var new_seed_instance = seed.instantiate()
		get_parent().add_child(new_seed_instance)
		new_seed_instance.transform = self.global_transform
