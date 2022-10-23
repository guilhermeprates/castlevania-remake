class_name HUD
extends CanvasLayer

onready var heartsLabel = $Control/HBoxContainer/HeartsLabel

func _process(delta: float) -> void:
	var hearts = PlayerVariables.hearts
	heartsLabel.text = "- " + str(hearts)
