extends Node2D

onready var _animated_sprite = $AnimatedSprite
var timer

func _ready() -> void:
	$AnimatedSprite.frame = 0

func _init() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 4.5
	timer.connect("timeout", self, "_timeout")

func _timeout():
	get_tree().change_scene("res://Source/Levels/Intro/Intro.tscn")
	print("Timed out")
