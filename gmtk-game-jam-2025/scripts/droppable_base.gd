extends RigidBody2D
class_name DroppableBase

signal droppable_collided

@export var droppable_id = SUIKA.DROPPABLES
@onready var _rng = RandomNumberGenerator.new()

var disabled = false

func _init():
	contact_monitor = true
	#maybe the bug is here?
	max_contacts_reported = 5
	
	var a_velocity = randi_range(PI/2, PI)
	self.angular_velocity = a_velocity
	if randi_range(0, 1) == 0:
		self.angular_velocity *= -1

func _physics_process(delta: float):
	var contacts = get_colliding_bodies()
	# var num = get_contact_count()
	if get_contact_count() > 1:
		
		if get_tree().current_scene.name == "MainMenu":
			return #We don't want to get rid of flowers in MainMenu
			
		for body in contacts: 
			if body is DroppableBase:
				# some bug in here? maybe an extra spawns? Why? Collision detection?
				# maybe a dropped flower touches more than one of a collision?
				if not body.disabled:
					# This is bad code to see if one of the dropped is prestiged, and if so, set the next evolution to be prestiged
					if (droppable_id == body.droppable_id) or abs(droppable_id - body.droppable_id) == 8:
						if not disabled: # have to check if original is disabled, else, other droppables would change too
							var isPrestiged = droppable_id >= 8 or body.droppable_id >=8
							disabled = true
							body.disabled = true
							var middle_point = position.lerp(body.position, .5)
							body.queue_free()
							# Create next evolution at self.position
							# Which means, if the sizes of the droppables
							# are unbalanced, game might look funky
							droppable_collided.emit(middle_point, droppable_id, isPrestiged)
							queue_free()
			pass
