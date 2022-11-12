extends CanvasLayer

onready var heartsLabel = $Control/HBoxContainer/HeartsLabel
onready var healthLabel = $Control/HBoxContainer2/HealthLabel
onready var timerLabel = $Control/HBoxContainer4/TimerLabel
onready var lifeBarPlayer = $Control/PlayerLifeBar
var timer = 300

func _process(delta: float) -> void:
	var hearts = PlayerVariables.hearts
	var health_points = PlayerVariables.health_points
	heartsLabel.text = "-" + str(hearts)
	healthLabel.text = "P-" + str(health_points)

	
func _on_Timer_timeout() -> void:
	timer -= 1
	timerLabel.text = "TIME 0" + str(timer)


