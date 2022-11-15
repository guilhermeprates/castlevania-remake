extends Control

func _ready() -> void:
	$Options/VBoxContainer2/Continue.grab_focus()

func _on_Continue_pressed() -> void:
	get_tree().change_scene("res://Source/Levels/Intro/Intro.tscn")

func _on_End_pressed() -> void:
	get_tree().change_scene("res://Source/Menu/Menu.tscn")
