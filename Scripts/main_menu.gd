extends Node2D

func _on_start_button_pressed():
	MusicManager.PlayGeneral(0)
	get_tree().change_scene_to_file("res://Scenes/main_level.tscn")
