extends Node2D


func _on_button_pressed():
	get_tree().change_scene_to_file("res://loading.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()