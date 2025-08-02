extends Control

var _seed_scene = preload("res://scenes/droppables/seed.tscn")
var _leaf_scene = preload("res://scenes/droppables/leaf.tscn")
var _daisy_scene = preload("res://scenes/droppables/daisy.tscn")
var _carnation_scene = preload("res://scenes/droppables/carnation.tscn")
var _bluebonnet_scene = preload("res://scenes/droppables/bluebonnet.tscn")
var _tulip_scene = preload("res://scenes/droppables/tulip.tscn")
var _rose_scene = preload("res://scenes/droppables/rose.tscn")
var _sunflower_scene = preload("res://scenes/droppables/sunflower.tscn")

@onready var pop_1: AudioStreamPlayer2D = $SFX/Pop1
@onready var pop_2: AudioStreamPlayer2D = $SFX/Pop2
@onready var pop_3: AudioStreamPlayer2D = $SFX/Pop3
@onready var rustle_1: AudioStreamPlayer2D = $SFX/Rustle1

@onready var spawnArea = $SpawnerArea2D/CollisionShape2D

@onready var _rng = RandomNumberGenerator.new()

var spawnTimer: Timer
var wait_time = 2.0

var _droppable_list = [_seed_scene, _leaf_scene, _daisy_scene, _carnation_scene, _bluebonnet_scene, _tulip_scene, _rose_scene, _sunflower_scene ]

func _ready():
	_startSpawn()
	#Unique Name Accesses (set from scene inspector)
	%StartButton.pressed.connect(_play)

func _play():
	# rustle_1.play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _startSpawn():
	spawnTimer = Timer.new()
	add_child(spawnTimer) # Add the timer to the scene tree
	spawnTimer.wait_time = wait_time # Set the duration of the timer
	# spawnTimer.one_shot = true # Make it a one-shot timer
	spawnTimer.connect("timeout", Callable(self, "_on_my_timer_timeout")) # Connect the timeout signal
	spawnTimer.start() # Start the timer

func _spawn_flower():
	var posX = spawnArea.global_position.x 
	var posY = spawnArea.global_position.y
	var offset = _rng.randf_range(-spawnArea.shape.size.x/2, spawnArea.shape.size.x/2)
	posX += offset
	
	var droppable_index =  _rng.randi_range(1, 7)
	var drop_temp = _droppable_list[droppable_index].instantiate()
	add_child(drop_temp)
	drop_temp.global_position.x = posX
	drop_temp.global_position.y = posY
	_play_random_pop()

func _on_my_timer_timeout():
	_spawn_flower()
	if wait_time > .8:
		wait_time -=.1
		spawnTimer.set_wait_time(wait_time)

func _play_random_pop():
	var temp = _rng.randi_range(0,2)
	match temp:
		0:
			pop_1.play()
		1:
			pop_2.play()
		2:
			pop_3.play()
		_:
			pop_1.play()
