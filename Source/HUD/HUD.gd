extends CanvasLayer

onready var heartsLabel = $Control/HeartsLabel

func _process(delta: float) -> void:
	var hearts = PlayerVariables.hearts
	heartsLabel.text = "- " + str(hearts)
