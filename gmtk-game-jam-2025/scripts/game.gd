extends Node2D

var _seed_scene = preload("res://scenes/droppables/seed.tscn")
var _leaf_scene = preload("res://scenes/droppables/leaf.tscn")
var _daisy_scene = preload("res://scenes/droppables/daisy.tscn")
var _carnation_scene = preload("res://scenes/droppables/carnation.tscn")
var _bluebonnet_scene = preload("res://scenes/droppables/bluebonnet.tscn")
var _tulip_scene = preload("res://scenes/droppables/tulip.tscn")
var _rose_scene = preload("res://scenes/droppables/rose.tscn")
var _sunflower_scene = preload("res://scenes/droppables/sunflower.tscn")

var _current_droppable

var _droppable_list = [_seed_scene, _leaf_scene, _daisy_scene, _carnation_scene, _bluebonnet_scene, _tulip_scene, _rose_scene, _sunflower_scene]

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	# if _waiting_to_spawn:

func _spawn_droppable(pos, droppable_id):
	_current_droppable = _droppable_list[droppable_id].instantiate()
	add_child(_current_droppable)
	# _current_droppable.droppable_collided.connect(_spawn_next_evolution)
	_current_droppable.droppable_collided.connect(_spawn_next_evolution)
	_current_droppable.position = pos

func _on_player_dropped_droppable(pos, droppable_id) -> void:
	# when player immediately drops a flower
	_spawn_droppable(pos, droppable_id)

func _spawn_next_evolution(position, droppable_id):
	# This is where the check happens to increase to next evolution
	# If we put powerups into Enum/etc. (which we should),
	# This check will need to be more robust so that sunflower doesn't turn
	# into Bumblebee, etc.
	var droppable_id_to_spawn = droppable_id + 1
	# Can't build higher than a sunflower (haven't coded prestige yet
	if droppable_id_to_spawn >= 8:
		printerr("HEY! THIS IS PAST COLE. WHEN TWO SUNFLOWERS (or whatever is the highest) collide, they will just disappear. This is set by an index in game.gd")
		return
	_spawn_droppable(position, droppable_id_to_spawn)
	
