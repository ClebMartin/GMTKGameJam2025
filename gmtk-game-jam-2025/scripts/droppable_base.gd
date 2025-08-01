extends RigidBody2D
class_name DroppableBase

signal droppable_collided

@export var droppable_id = SUIKA.DROPPABLES

var disabled = false

func _init():
	contact_monitor = true
	#maybe the bug is here?
	max_contacts_reported = 5

func _physics_process(delta: float):
	var contacts = get_colliding_bodies()
	# var num = get_contact_count()
	if get_contact_count() > 1:
		for body in contacts: 
			if body is DroppableBase:
				# some bug in here? maybe an extra spawns? Why? Collision detection?
				# maybe a dropped flower touches more than one of a collision?
				if not body.disabled:
					if droppable_id == body.droppable_id:
						disabled = true
						body.disabled = true
						body.queue_free()
						# Create next evolution at self.position
						# Which means, if the sizes of the droppables
						# are unbalanced, game might look funky
						droppable_collided.emit(position, droppable_id)
						queue_free()
			pass
