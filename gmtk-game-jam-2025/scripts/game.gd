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

@onready var _seed_img = $QueueGroup/Seed
@onready var _leaf_img = $QueueGroup/Leaf
@onready var _daisy_img = $QueueGroup/Daisy
@onready var _carnation_img = $QueueGroup/Carnation
# Technically, right now, player will never anything above a carnation
# but, in order to not have a possible bug, I'll add them here.
@onready var _bluebonnet_img = $QueueGroup/Bluebonnet
@onready var _tulip_img = $QueueGroup/Tulip
@onready var _rose_img = $QueueGroup/Rose
@onready var _sunflower_img = $QueueGroup/Sunflower

var _mergeParticle_scene = preload("res://scenes/utils/mergeParticle.tscn")

var _current_droppable

var _next_droppable
var _next_droppable_id
var _next_droppable_img_list

var _droppable_list = [_seed_scene, _leaf_scene, _daisy_scene, _carnation_scene, _bluebonnet_scene, _tulip_scene, _rose_scene, _sunflower_scene, _seed_prestige_scene, _leaf_prestige_scene, _daisy_prestige_scene, _carnation_prestige_scene, _bluebonnet_prestige_scene, _tulip_prestige_scene, _rose_prestige_scene, _sunflower_prestige_scene]

@onready var ScoreLabel = $ScoreGroup/ScoreLabel
var _score = 0
var _drop_value = 1 # score addition for everytime you successfully drop a droppable

@onready var NumFlowerLabel = $NumFlowerGroup/NumFlowerLabel
var _num_flowers_dropped = 0

var PlayerNode

@onready var _rng = RandomNumberGenerator.new()

func _ready() -> void:
	_set_up_list()
	PlayerNode = get_node("Player")
	PlayerNode.next_droppable_id_signal.connect(_next_drop_id)
	
	_next_droppable_id = PlayerNode._next_droppable_id
	_next_droppable = _next_droppable_img_list[_next_droppable_id]
	_next_droppable.show()
	
	ScoreLabel.text = str(_score)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("close"):
		# get_tree().quit()
		print("Do we show a pause menu?")
	# if _waiting_to_spawn:

func _spawn_droppable(pos, droppable_id, rot = 0):
	_current_droppable = _droppable_list[droppable_id].instantiate()
	add_child(_current_droppable)
	# _current_droppable.droppable_collided.connect(_spawn_next_evolution)
	_current_droppable.droppable_collided.connect(_spawn_next_evolution)
	_current_droppable.position = pos
	_current_droppable.rotation = rot

func _on_player_dropped_droppable(pos, droppable_id) -> void:
	# when player immediately drops a flower
	_spawn_droppable(pos, droppable_id)
	_set_score(_drop_value)
	_increment_num_flowers_dropped()

func _spawn_next_evolution(position, droppable_id, isPrestiged = false):
	# This is where the check happens to increase to next evolution
	# If we put powerups into Enum/etc. (which we should),
	# This check will need to be more robust so that sunflower doesn't turn
	# into Bumblebee, etc.
	var droppable_id_to_spawn = droppable_id + 1
	
	if isPrestiged and droppable_id_to_spawn < 8:
		droppable_id_to_spawn += 8
	
	# droppable multiplier set here
	
	# If prestiged sunflower combine, created normal prestiged seed
	# LOOOOOOOOOOOOOOOOOOOOOOOOOP
	if droppable_id_to_spawn > 15:
		droppable_id_to_spawn = 8
	
	# Make Spawnable rotated on instantiate
	var rotate = _rng.randi_range(0, 60)
	if _rng.randi_range(0, 1) == 0:
		rotate *= -1
		
	_spawn_droppable(position, droppable_id_to_spawn, rotate)
	_set_score(_get_droppable_value(droppable_id_to_spawn))
	
	var particle_inst = load("res://scenes/utils/mergeParticle.tscn").instantiate()
	add_child(particle_inst)
	particle_inst.position = position

func _get_score():
	return _score

func _set_score(value):
	_score += value
	ScoreLabel.text = str(_score)

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

func _get_num_flowers_dropped():
	return _num_flowers_dropped

func _increment_num_flowers_dropped():
	_num_flowers_dropped += 1
	NumFlowerLabel.text = str(_num_flowers_dropped)

func _reset_num_flowers_dropped():
	#Not using this yet, unless we need to clean up
	_num_flowers_dropped = 0

func _next_drop_id(id):
	_next_droppable.hide()
	_next_droppable_id = id
	_next_droppable = _next_droppable_img_list[_next_droppable_id]
	_next_droppable.show()
	
func _set_up_list():
	_next_droppable_img_list = [
		_seed_img,
		_leaf_img,
		_daisy_img,
		_carnation_img,
		_bluebonnet_img,
		_tulip_img,
		_rose_img,
		_sunflower_img
	]
