extends Control

var _seed_scene = preload("res://scenes/droppables/seed.tscn")
var _leaf_scene = preload("res://scenes/droppables/leaf.tscn")
var _daisy_scene = preload("res://scenes/droppables/daisy.tscn")
var _carnation_scene = preload("res://scenes/droppables/carnation.tscn")
var _bluebonnet_scene = preload("res://scenes/droppables/bluebonnet.tscn")
var _tulip_scene = preload("res://scenes/droppables/tulip.tscn")
var _rose_scene = preload("res://scenes/droppables/rose.tscn")
var _sunflower_scene = preload("res://scenes/droppables/sunflower.tscn")

@onready var spawnArea = $SpawnerArea2D/CollisionShape2D

@onready var _rng = RandomNumberGenerator.new()

var spawnTimer: Timer
var wait_time = 2.0

var _droppable_list = [_seed_scene, _leaf_scene, _daisy_scene, _carnation_scene, _bluebonnet_scene, _tulip_scene, _rose_scene, _sunflower_scene ]

func _ready():
	_startSpawn()
	#Unique Name Accesses (set from scene inspector)
	%StartButton.pressed.connect(_play)
	%QuitButton.pressed.connect(_quit)

func _play():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _quit():
	get_tree().quit()

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
	
	var droppable_index =  _rng.randi_range(2, 7)
	var drop_temp = _droppable_list[droppable_index].instantiate()
	add_child(drop_temp)
	drop_temp.global_position.x = posX
	drop_temp.global_position.y = posY

func _on_my_timer_timeout():
	_spawn_flower()
	if wait_time > .8:
		wait_time -=.1
		spawnTimer.set_wait_time(wait_time)
