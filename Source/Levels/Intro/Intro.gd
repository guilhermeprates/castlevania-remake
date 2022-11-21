class_name Intro
extends Node2D

onready var stage1OST: AudioStreamPlayer = $Stage1OST
onready var castleSFX: AudioStreamPlayer = $CastleSFX
onready var timer: Timer = $Timer

func _ready() -> void:
	stage1OST.play()
	timer.connect("timeout", self, "_on_timeout")

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		castleSFX.play()
		timer.start()

func _on_timeout() ->void:
	get_tree().change_scene("res://Source/Levels/Level1/Level1.tscn")
