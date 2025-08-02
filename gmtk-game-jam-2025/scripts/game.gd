extends Node2D

var _seed_scene = preload("res://scenes/droppables/seed.tscn")
var _leaf_scene = preload("res://scenes/droppables/leaf.tscn")
var _daisy_scene = preload("res://scenes/droppables/daisy.tscn")
var _carnation_scene = preload("res://scenes/droppables/carnation.tscn")
var _bluebonnet_scene = preload("res://scenes/droppables/bluebonnet.tscn")
var _tulip_scene = preload("res://scenes/droppables/tulip.tscn")
var _rose_scene = preload("res://scenes/droppables/rose.tscn")
var _sunflower_scene = preload("res://scenes/droppables/sunflower.tscn")
var _seed_prestige_scene = preload("res://scenes/droppables/seed_prestige.tscn")
var _leaf_prestige_scene = preload("res://scenes/droppables/leaf_prestige.tscn")
var _daisy_prestige_scene = preload("res://scenes/droppables/daisy_prestige.tscn")
var _carnation_prestige_scene = preload("res://scenes/droppables/carnation_prestige.tscn")
var _bluebonnet_prestige_scene = preload("res://scenes/droppables/bluebonnet_prestige.tscn")
var _tulip_prestige_scene = preload("res://scenes/droppables/tulip_prestige.tscn")
var _rose_prestige_scene = preload("res://scenes/droppables/rose_prestige.tscn")
var _sunflower_prestige_scene = preload("res://scenes/droppables/sunflower_prestige.tscn")

var _current_droppable

var _droppable_list = [_seed_scene, _leaf_scene, _daisy_scene, _carnation_scene, _bluebonnet_scene, _tulip_scene, _rose_scene, _sunflower_scene, _seed_prestige_scene, _leaf_prestige_scene, _daisy_prestige_scene, _carnation_prestige_scene, _bluebonnet_prestige_scene, _tulip_prestige_scene, _rose_prestige_scene, _sunflower_prestige_scene]

@onready var ScoreLabel = $ScoreLabel
var _score = 0
var _drop_value = 1 # score addition for everytime you successfully drop a droppable

func _ready() -> void:
	ScoreLabel.text = str(_score)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("close"):
		# get_tree().quit()
		print("Do we show a pause menu?")
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
	_set_score(_drop_value)

func _spawn_next_evolution(position, droppable_id):
	# This is where the check happens to increase to next evolution
	# If we put powerups into Enum/etc. (which we should),
	# This check will need to be more robust so that sunflower doesn't turn
	# into Bumblebee, etc.
	var droppable_id_to_spawn = droppable_id + 1
	
	# If prestiged sunflower combine, created normal prestiged seed
	# LOOOOOOOOOOOOOOOOOOOOOOOOOP
	if droppable_id_to_spawn >= 15:
		droppable_id_to_spawn = 8
		
	_spawn_droppable(position, droppable_id_to_spawn)
	_set_score(_get_droppable_value(droppable_id_to_spawn))


func _get_score():
	return _score

func _set_score(value):
	_score += value
	ScoreLabel.text = str(_score)
	print(_get_score())

func _reset_score():
	# This isn't called anywhere yet
	_score = 0

func _get_droppable_value(id):
	var scoreArray = [
		5,  # seed
		10, # leaf
		15, # daisy
		20, # carnation
		25, # bluebonnet
		50, # tulip
		75, # rose
		100, # sunflower
		200, # seed_p
		400, # leaf_p
		800, # daisy_p
		1600, # carnation_p
		3200, # bluebonnet_p
		5000, # stulip_p
		7500, # rose_p
		10000 # sunflower_p
	]
	return scoreArray[id]
