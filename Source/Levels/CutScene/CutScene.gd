class_name CutScene
extends Node2D

onready var _animated_sprite := $AnimatedSprite
onready var _cutscene_song := $AudioStreamPlayer 
onready var _timer := $Timer
onready var _animation_timer := $AnimtationTimer

func _ready() -> void:
	_timer.connect("timeout", self, "_cutscene_timeout")
	_animation_timer.connect("timeout", self, "_animation_timeout")
	_cutscene_song.play()
	_animated_sprite.frame = 0

func _cutscene_timeout():
	get_tree().change_scene("res://Source/Levels/Intro/Intro.tscn")

func _animation_timeout():
	_animated_sprite.stop()
	_animated_sprite.frame = 17
