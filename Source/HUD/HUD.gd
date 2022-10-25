extends CanvasLayer

onready var heartsLabel = $Control/HBoxContainer/HeartsLabel
onready var healthLabel = $Control/HBoxContainer/HealthLabel

func _process(delta: float) -> void:
	var hearts = PlayerVariables.hearts
	var health = PlayerVariables.health
	heartsLabel.text = "- " + str(hearts)
	healthLabel.text = "Health - " + str(health)
