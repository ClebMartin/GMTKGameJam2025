extends Node2D

@export var PLAYER_SPEED = 5
@export var DROP_COOLDOWN = 60

# var _seed_scene = preload("res://scenes/droppables/seed1.tscn")
@onready var _seed_img = $Seed
@onready var _leaf_img = $Leaf
@onready var _daisy_img = $Daisy
@onready var _carnation_img = $Carnation
# Technically, right now, player will never anything above a carnation
# but, in order to not have a possible bug, I'll add them here.
@onready var _bluebonnet_img = $Bluebonnet
@onready var _tulip_img = $Tulip
@onready var _rose_img = $Rose
@onready var _sunflower_img = $Sunflower

@onready var _rng = RandomNumberGenerator.new()

# indexes same as GameScript
var _droppable_img_list

signal dropped_droppable

var _current_droppable
var _current_droppable_id = 0

# For "Queue" in Game
var _next_droppable_id
signal next_droppable_id_signal

var _tick = 0
var _waiting_to_spawn = false

const FOLLOW_SPEED = 3.8

func _pick_random_droppable():
	# only return index for seed, leaf, daisy, or carnation.
	return _rng.randi_range(0, 3)
	
func _spawn_new_droppable():
	_current_droppable_id = _next_droppable_id
	_next_droppable_id = _pick_random_droppable()
	_current_droppable = _droppable_img_list[_current_droppable_id]
	_current_droppable.show()
	next_droppable_id_signal.emit(_next_droppable_id)

func _ready():
	_set_up_list()
	_next_droppable_id = 0
	_spawn_new_droppable()

func _physics_process(delta):
	var target_x = get_global_mouse_position().x
	
	# if Input.is_action_pressed("left"):
	#	target_x = position.x - (FOLLOW_SPEED * 10) # Use a speed multiplier for keyboard
	# elif Input.is_action_pressed("right"):
	#	target_x = position.x + (FOLLOW_SPEED * 10)

	var droppable_half_width = (_current_droppable.texture.get_width() * _current_droppable.scale.x) / 2
	var clamp_min = 330 + droppable_half_width
	var clamp_max = 650 - droppable_half_width
	var clamped_target_x = clamp(target_x, clamp_min, clamp_max)
	position.x = lerp(position.x, clamped_target_x, delta * FOLLOW_SPEED)
	
	if Input.is_action_pressed("drop") && !_waiting_to_spawn:
		_drop()

	if _waiting_to_spawn:
		_ticker()
	pass
	
func _drop():
	_current_droppable.hide()
	_waiting_to_spawn = true
	dropped_droppable.emit(position, _current_droppable_id)

func _ticker():
	_tick += 1
	if _tick > DROP_COOLDOWN:
		_tick = 0
		_spawn_new_droppable()
		_waiting_to_spawn = false

func _set_up_list():
	_droppable_img_list = [
		_seed_img,
		_leaf_img,
		_daisy_img,
		_carnation_img,
		_bluebonnet_img,
		_tulip_img,
		_rose_img,
		_sunflower_img
	]
