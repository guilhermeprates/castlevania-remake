class_name TextLevel 
extends Level

export(Resource) var Item

var objects = []

onready var scene = preload("res://Source/HUD/Heartzinho.tscn")

func _ready() -> void:
	for node in get_children():
		if node is ItemBox:
			print("qualquer coisa")
			node.connect("on_break_object", self, "_on_break_object")

func _process(delta: float) -> void:
	pass

func _on_break_object(position) -> void: 
	var item = scene.instance()
	item.position = position
	add_child(item)
	print(position)

