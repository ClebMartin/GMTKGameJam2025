extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if get_tree().current_scene.name == "MainMenu":
		body.queue_free()
	else:
		#save highest score
		await SaveLoad.save_score()
		get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
