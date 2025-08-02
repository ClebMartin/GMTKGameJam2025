extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
