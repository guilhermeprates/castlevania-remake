class_name Level
extends Node2D

export(Array, Resource) var items: Array = []

onready var collectableScene = preload("res://Source/Items/Collectable.tscn")

func _ready() -> void:
	for node in get_children():
		if node is LevelObject:
			node.connect("on_break_level_object", self, "_spawn_item")

func _process(delta: float) -> void:
	pass

func _spawn_item(position: Vector2) -> void:
	print(position)
	var collectable = collectableScene.instance()
	collectable.item = items[0]
	collectable.position = position
	yield(get_tree().create_timer(0.5), "timeout")
	call_deferred("add_child", collectable)
	

