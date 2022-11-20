class_name Level
extends Node2D

export(Array, Resource) var items: Array = []

onready var collectableScene = preload("res://Source/Items/Collectable.tscn")

func _ready() -> void:
	for node in get_children():
		if node is LevelObject:
			node.queue_free()
			node.connect("on_break_level_object", self, "_spawn_item")
		if node is SpawnArea:
			node.connect("on_spawn_enemy", self, "_spawn_enemy")

func _spawn_item(position: Vector2) -> void:
	print(position)
	var collectable = collectableScene.instance()
#	collectable.item = items[0]
	collectable.position = position
	collectable.connect("on_touch_collectable", self, "_collect_item")
	yield(get_tree().create_timer(0.5), "timeout")
	call_deferred("add_child", collectable)

func _spawn_enemy(enemy: Enemy) -> void:
	enemy.connect("on_kill_enemy", self, "_spawn_item")
	call_deferred("add_child", enemy)

func _collect_item() -> void:
	Game.player_hearts += 1
	print(str(Game.player_hearts))
