extends Node2D

func _ready() -> void:
	pass

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		get_tree().change_scene("res://Source/Levels/Level1/Level1.tscn")
