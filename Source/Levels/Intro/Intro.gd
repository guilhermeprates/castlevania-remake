class_name Intro
extends Node2D

onready var stage1OST: AudioStreamPlayer = $Stage1OST
onready var castleSFX: AudioStreamPlayer = $CastleSFX

func _ready() -> void:
	stage1OST.play()
	castleSFX.connect("finished", self, "_on_castlesfx_finished")

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		castleSFX.play()
		
func _on_castlesfx_finished() -> void:
	get_tree().change_scene("res://Source/Levels/Level1/Level1.tscn")
