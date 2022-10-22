class_name Level
extends Node2D

func _ready() -> void:
	for node in get_children():
		if node is LevelObject:
			node.connect("on_break_level_object", self, "_on_break_level_object")

func _process(delta: float) -> void:
	pass

func _on_break_level_object(position) -> void:
	print(position)
